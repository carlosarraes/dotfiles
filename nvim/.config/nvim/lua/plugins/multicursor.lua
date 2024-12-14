return {
  "jake-stewart/multicursor.nvim",
  branch = "1.0",
  config = function()
    local mc = require("multicursor-nvim")

    mc.setup({})
    -- Add or skip cursor above/below the main cursor.
    vim.keymap.set({ "n", "v" }, "<up>", function()
      mc.lineAddCursor(-1)
    end)
    vim.keymap.set({ "n", "v" }, "<down>", function()
      mc.lineAddCursor(1)
    end)
    vim.keymap.set({ "n", "v" }, ";k", function()
      mc.lineSkipCursor(-1)
    end)
    vim.keymap.set({ "n", "v" }, ";j", function()
      mc.lineSkipCursor(1)
    end)

    -- Add or skip adding a new cursor by matching the current word/selection
    vim.keymap.set("v", "<leader>n", function()
      mc.matchAddCursor(1)
    end)
    vim.keymap.set({ "n", "v" }, "<leader>s", function()
      mc.matchSkipCursor(1)
    end)
    vim.keymap.set({ "n", "v" }, "<leader>N", function()
      mc.matchAddCursor(-1)
    end)
    vim.keymap.set({ "n", "v" }, "<leader>S", function()
      mc.matchSkipCursor(-1)
    end)

    -- You can also add cursors with any motion you prefer:
    -- vim.keymap.set("n", "<right>", function() mc.addCursor("w") end)
    -- vim.keymap.set("n", "<leader><right>", function() mc.skipCursor("w") end)

    -- Add a cursor and jump to the next word under cursor.
    vim.keymap.set("v", "<c-n>", function()
      mc.addCursor("*")
    end)

    -- Jump to the next word under cursor but do not add a cursor.
    vim.keymap.set("v", "<c-s>", function()
      mc.skipCursor("*")
    end)

    -- Rotate the main cursor.
    vim.keymap.set({ "n", "v" }, "<left>", mc.nextCursor)
    vim.keymap.set({ "n", "v" }, "<right>", mc.prevCursor)

    -- Delete the main cursor.
    vim.keymap.set("v", "<leader>x", mc.deleteCursor)

    -- Add and remove cursors with control + left click.
    vim.keymap.set("n", "<c-leftmouse>", mc.handleMouse)

    vim.keymap.set({ "n", "v" }, "<c-q>", function()
      if mc.cursorsEnabled() then
        -- Stop other cursors from moving.
        -- This allows you to reposition the main cursor.
        mc.disableCursors()
      else
        mc.addCursor()
      end
    end)

    -- clone every cursor and disable the originals
    vim.keymap.set({ "n", "v" }, "<leader><c-q>", mc.duplicateCursors)

    vim.keymap.set("n", "<esc>", function()
      if not mc.cursorsEnabled() then
        mc.enableCursors()
      elseif mc.hasCursors() then
        mc.clearCursors()
      else
        -- Default <esc> handler.
      end
    end)

    -- Align cursor columns.
    vim.keymap.set("v", "<leader>a", mc.alignCursors)

    -- Split visual selections by regex.
    vim.keymap.set("v", "S", mc.splitCursors)

    -- Append/insert for each line of visual selections.
    vim.keymap.set("v", "I", mc.insertVisual)
    vim.keymap.set("v", "A", mc.appendVisual)

    -- match new cursors within visual selections by regex.
    vim.keymap.set("v", "M", mc.matchCursors)

    -- Rotate visual selection contents.
    vim.keymap.set("v", "<leader>t", function()
      mc.transposeCursors(1)
    end)
    vim.keymap.set("v", "<leader>T", function()
      mc.transposeCursors(-1)
    end)

    -- Customize how cursors look.
    vim.api.nvim_set_hl(0, "MultiCursorCursor", { link = "Cursor" })
    vim.api.nvim_set_hl(0, "MultiCursorVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorSign", { link = "SignColumn" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
    vim.api.nvim_set_hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
  end,
}
