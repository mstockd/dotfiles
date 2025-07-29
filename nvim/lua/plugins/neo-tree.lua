return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
      window = {
        mappings = {
          ["<space>"] = "none",
          ["<tab>"] = "toggle_node",
        }
      }
    },
    keys = {
      { "<leader>n", ":Neotree filesystem toggle left<CR>", desc = "Toggle Neo-tree" }
    }
  }
}
