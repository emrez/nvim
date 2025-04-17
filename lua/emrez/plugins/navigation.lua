return {
  -- Improved surround functionality
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",
          insert_line = "<C-g>S",
          normal = "ys",
          normal_cur = "yss",
          normal_line = "yS",
          normal_cur_line = "ySS",
          visual = "S",
          visual_line = "gS",
          delete = "ds",
          change = "cs",
        },
      })
    end,
  },
  -- Fast cursor movement with leap
  {
    "ggandor/leap.nvim",
    dependencies = { "tpope/vim-repeat" },
    config = function()
      require("leap").add_default_mappings()
      require('leap').opts.preview_filter =
        function (ch0, ch1, ch2)
          return not (
            ch1:match('%s') or
            ch0:match('%a') and ch1:match('%a') and ch2:match('%a')
          )
        end
    end,
  },
}
