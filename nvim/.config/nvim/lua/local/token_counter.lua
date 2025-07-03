local M = {}

M.config = {
  provider = "anthropic", -- default to anthropic
  anthropic_api_key = vim.env.ANTHROPIC_API_KEY,
  gemini_api_key = vim.env.GEMINI_API_KEY,
  gemini_project_id = vim.env.GEMINI_PROJECT_ID or "your-project-id",
  gemini_location = vim.env.GEMINI_LOCATION or "us-central1",
  cache_timeout = 300000, -- 5 minutes cache timeout (much longer)
  enabled = true,
}

local cache = {}
local current_request_hash = nil -- Track current ongoing request

local function get_buffer_content()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  return table.concat(lines, "\n")
end

local function hash_content(content)
  return tostring(vim.fn.sha256(content))
end

local function is_cache_valid(hash)
  local entry = cache[hash]
  if not entry then
    return false
  end
  return os.time() * 1000 - entry.timestamp < M.config.cache_timeout
end

local function anthropic_count_tokens(content, callback)
  if not M.config.anthropic_api_key then
    callback({ error = "ANTHROPIC_API_KEY not set" })
    return
  end

  local data = vim.json.encode({
    model = "claude-3-5-sonnet-20241022",
    messages = {
      { role = "user", content = content }
    }
  })

  local cmd = {
    "curl",
    "-s",
    "-X", "POST",
    "https://api.anthropic.com/v1/messages/count_tokens",
    "-H", "x-api-key: " .. M.config.anthropic_api_key,
    "-H", "anthropic-version: 2023-06-01",
    "-H", "content-type: application/json",
    "-d", data
  }

  vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        local ok, json = pcall(vim.json.decode, obj.stdout)
        if ok and json.input_tokens then
          callback({ tokens = json.input_tokens, provider = "anthropic" })
        else
          callback({ error = "Failed to parse response" })
        end
      else
        callback({ error = "API request failed: " .. (obj.stderr or "Unknown error") })
      end
    end)
  end)
end

local function gemini_count_tokens(content, callback)
  if not M.config.gemini_api_key then
    callback({ error = "GEMINI_API_KEY not set" })
    return
  end

  -- Use Google AI Studio API (free) instead of Vertex AI
  local url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:countTokens?key=" .. M.config.gemini_api_key

  local data = vim.json.encode({
    contents = {
      {
        parts = {
          { text = content }
        }
      }
    }
  })

  local cmd = {
    "curl",
    "-s",
    "-X", "POST",
    url,
    "-H", "Content-Type: application/json",
    "-d", data
  }

  vim.system(cmd, { text = true }, function(obj)
    vim.schedule(function()
      if obj.code == 0 then
        local ok, json = pcall(vim.json.decode, obj.stdout)
        if ok and json.totalTokens then
          callback({ tokens = json.totalTokens, provider = "gemini" })
        elseif ok and json.error then
          callback({ error = "Gemini API error: " .. (json.error.message or "Unknown") })
        else
          callback({ error = "Failed to parse response: " .. obj.stdout })
        end
      else
        callback({ error = "API request failed: " .. (obj.stderr or "Unknown error") })
      end
    end)
  end)
end

function M.count_tokens(callback)
  if not M.config.enabled then
    callback({ error = "Token counter disabled" })
    return
  end

  local content = get_buffer_content()
  
  if content == "" then
    callback({ tokens = 0, provider = "none" })
    return
  end

  local content_hash = hash_content(content)
  
  -- If we already have a valid cached result, use it
  if is_cache_valid(content_hash) then
    callback(cache[content_hash].result)
    return
  end
  
  -- If we're already processing this exact content, don't make another request
  if current_request_hash == content_hash then
    return
  end
  
  current_request_hash = content_hash

  local function handle_result(result)
    current_request_hash = nil -- Clear the ongoing request
    if not result.error then
      cache[content_hash] = {
        result = result,
        timestamp = os.time() * 1000
      }
    end
    callback(result)
  end

  if M.config.provider == "anthropic" then
    anthropic_count_tokens(content, handle_result)
  elseif M.config.provider == "gemini" then
    gemini_count_tokens(content, handle_result)
  else
    current_request_hash = nil
    callback({ error = "Unknown provider: " .. M.config.provider })
  end
end

function M.get_status()
  local content = get_buffer_content()
  if content == "" then
    return ""
  end

  local content_hash = hash_content(content)
  if is_cache_valid(content_hash) then
    local result = cache[content_hash].result
    if result.error then
      -- Show the actual error for debugging
      return "📊 " .. result.error:sub(1, 20)
    else
      return string.format("📊 %d (%s)", result.tokens, result.provider)
    end
  end

  return "📊 ..."
end

-- Debug function to test API manually
function M.debug_test()
  local content = "Hello world, this is a test."
  print("Testing with content:", content)
  M.count_tokens(function(result)
    if result.error then
      print("Error:", result.error)
    else
      print("Success:", result.tokens, "tokens from", result.provider)
    end
  end)
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})
end

-- Provider switching functions
function M.anthropic()
  M.config.provider = "anthropic"
  -- Clear cache to force refresh with new provider
  cache = {}
  current_request_hash = nil
  print("Token counter switched to Anthropic")
  -- Trigger immediate recount
  M.count_tokens(function()
    vim.cmd('redrawstatus')
  end)
end

function M.gemini()
  M.config.provider = "gemini"
  -- Clear cache to force refresh with new provider
  cache = {}
  current_request_hash = nil
  print("Token counter switched to Gemini")
  -- Trigger immediate recount
  M.count_tokens(function()
    vim.cmd('redrawstatus')
  end)
end

function M.next_provider()
  if M.config.provider == "anthropic" then
    M.gemini()
  else
    M.anthropic()
  end
end

function M.get_provider()
  return M.config.provider
end

return M