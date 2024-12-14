return {
  "tpope/vim-surround",
  "tpope/vim-abolish",
  "tpope/vim-fugitive",
  "SmiteshP/nvim-navic",
  "mbbill/undotree",
  {
    "tronikelis/ts-autotag.nvim",
    opts = {},
    -- ft = {}, optionally you can load it only in jsx/html
    event = "VeryLazy",
  },
  {
    "tpope/vim-dadbod",
    dependencies = {
      "kristijanhusak/vim-dadbod-ui",
      "kristijanhusak/vim-dadbod-completion",
    },
  },
  { "stevearc/dressing.nvim", event = "VeryLazy" },
}
