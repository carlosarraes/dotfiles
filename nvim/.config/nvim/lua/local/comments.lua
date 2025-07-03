local M = {}

function M.remove_comments(comment_type)
  local bufnr = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[bufnr].filetype
  
  if filetype == "" then
    vim.notify("No filetype detected", vim.log.levels.WARN)
    return
  end

  local parser = vim.treesitter.get_parser(bufnr, filetype)
  if not parser then
    vim.notify("Treesitter parser not available for filetype: " .. filetype, vim.log.levels.ERROR)
    return
  end

  local tree = parser:parse()[1]
  local root = tree:root()
  
  local comments = {}
  
  local function collect_comments(node)
    local node_type = node:type()
    
    local should_collect = false
    if not comment_type then
      should_collect = node_type:match("comment")
    elseif comment_type == "line" then
      should_collect = node_type:match("line_comment") or node_type == "comment" and not node_type:match("block")
    elseif comment_type == "block" then
      should_collect = node_type:match("block_comment") or node_type:match("multiline_comment")
    end
    
    if should_collect then
      local start_row, start_col, end_row, end_col = node:range()
      table.insert(comments, {
        start_row = start_row,
        start_col = start_col,
        end_row = end_row,
        end_col = end_col
      })
    end
    
    for child in node:iter_children() do
      collect_comments(child)
    end
  end
  
  collect_comments(root)
  
  table.sort(comments, function(a, b)
    return a.start_row > b.start_row or (a.start_row == b.start_row and a.start_col > b.start_col)
  end)
  
  for _, comment in ipairs(comments) do
    if comment.start_row == comment.end_row then
      local line = vim.api.nvim_buf_get_lines(bufnr, comment.start_row, comment.start_row + 1, false)[1]
      if line then
        local before = line:sub(1, comment.start_col)
        local after = line:sub(comment.end_col + 1)
        local new_line = before .. after
        
        if new_line:match("^%s*$") then
          vim.api.nvim_buf_set_lines(bufnr, comment.start_row, comment.start_row + 1, false, {})
        else
          vim.api.nvim_buf_set_lines(bufnr, comment.start_row, comment.start_row + 1, false, {new_line})
        end
      end
    else
      local lines = vim.api.nvim_buf_get_lines(bufnr, comment.start_row, comment.end_row + 1, false)
      if #lines > 0 then
        local first_line = lines[1]
        local last_line = lines[#lines]
        
        local before = first_line:sub(1, comment.start_col)
        local after = last_line:sub(comment.end_col + 1)
        local new_line = before .. after
        
        if new_line:match("^%s*$") then
          vim.api.nvim_buf_set_lines(bufnr, comment.start_row, comment.end_row + 1, false, {})
        else
          vim.api.nvim_buf_set_lines(bufnr, comment.start_row, comment.end_row + 1, false, {new_line})
        end
      end
    end
  end
  
  local removed_count = #comments
  local type_desc = comment_type and (comment_type .. " comments") or "comments"
  vim.notify("Removed " .. removed_count .. " " .. type_desc, vim.log.levels.INFO)
end

return M