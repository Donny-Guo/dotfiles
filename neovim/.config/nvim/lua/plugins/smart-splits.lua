return {
  "mrjones2014/smart-splits.nvim",
  build = "./kitty/install-kittens.bash",
  -- config = function()
  --   local smart_splits = require("smart-splits")
  --   smart_splits.setup({
  --     multiplexer_integration = "kitty",
  --     at_edge = function(ctx)
  --       return ctx.mux.next_pane(ctx.direction)
  --     end,
  --   })
  -- end,
  keys = {
    {
      "<C-h>",
      function()
        require("smart-splits").move_cursor_left()
      end,
      desc = "Move to left window",
    },
    {
      "<C-l>",
      function()
        require("smart-splits").move_cursor_right()
      end,
      desc = "Move to right window",
    },
    {
      "<C-j>",
      function()
        require("smart-splits").move_cursor_down()
      end,
      desc = "Move to below window",
    },
    {
      "<C-k>",
      function()
        require("smart-splits").move_cursor_up()
      end,
      desc = "Move to above window",
    },
    {
      "<A-h>",
      function()
        require("smart-splits").resize_left()
      end,
      desc = "Resize left window",
    },
    {
      "<A-l>",
      function()
        require("smart-splits").resize_right()
      end,
      desc = "Resize right window",
    },
    {
      "<A-j>",
      function()
        require("smart-splits").resize_down()
      end,
      desc = "Resize below window",
    },
    {
      "<A-k>",
      function()
        require("smart-splits").resize_up()
      end,
      desc = "Resize above window",
    },
  },
}
