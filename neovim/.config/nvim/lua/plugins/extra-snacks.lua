return {
  "folke/snacks.nvim",
  keys = {
    {
      "<leader>t",
      function()
        local terminals = Snacks.terminal.list()
        if #terminals == 0 then
          Snacks.notify.warn("No terminal sessions")
          return
        end

        local HEADER_LINES = 1
        local FOOTER = " <space> → toggle  <Enter> → close selected  a → close all  q → quit"
        local items = {}
        local max_len = #FOOTER

        for i, term in ipairs(terminals) do
          local title = (term.buf and vim.b[term.buf] and vim.b[term.buf].term_title) or ("Terminal " .. i)
          items[i] = { term = term, title = title, selected = false }
          local line_len = 7 + #tostring(i) + #title
          if line_len > max_len then
            max_len = line_len
          end
        end

        local width = math.min(max_len + 4, math.floor(vim.o.columns * 0.8))
        local height = HEADER_LINES + #items + 2

        local buf = vim.api.nvim_create_buf(false, true)
        vim.bo[buf].modifiable = true

        local lines = { "" }
        for i, item in ipairs(items) do
          lines[HEADER_LINES + i] = "   #" .. i .. ": " .. item.title
        end
        lines[#lines + 1] = ""
        lines[#lines + 1] = FOOTER
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        vim.bo[buf].modifiable = false

        local win = vim.api.nvim_open_win(buf, true, {
          relative = "editor",
          width = width,
          height = height,
          row = math.floor((vim.o.lines - height) / 2),
          col = math.floor((vim.o.columns - width) / 2),
          style = "minimal",
          border = "rounded",
          title = " Terminals ",
          title_pos = "center",
        })

        vim.api.nvim_win_set_cursor(win, { HEADER_LINES + 1, 0 })

        local function close_win()
          pcall(vim.api.nvim_win_close, win, true)
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end

        local function update_line(idx)
          local item = items[idx]
          local mark = item.selected and " ✖ " or "   "
          local line = mark .. "#" .. idx .. ": " .. item.title
          local row = HEADER_LINES + idx - 1
          vim.bo[buf].modifiable = true
          vim.api.nvim_buf_set_lines(buf, row, row + 1, false, { line })
          vim.bo[buf].modifiable = false
        end

        local kopts = { buffer = buf, nowait = true }

        vim.keymap.set("n", "<space>", function()
          local idx = vim.api.nvim_win_get_cursor(win)[1] - HEADER_LINES
          if idx < 1 or idx > #items then
            return
          end
          items[idx].selected = not items[idx].selected
          update_line(idx)
          if idx < #items then
            vim.api.nvim_win_set_cursor(win, { HEADER_LINES + idx + 1, 0 })
          end
        end, kopts)

        vim.keymap.set("n", "<cr>", function()
          local closed = 0
          for _, item in ipairs(items) do
            if item.selected then
              item.term:close()
              closed = closed + 1
            end
          end
          close_win()
          if closed == 0 then
            Snacks.notify.info("No terminals selected")
          else
            Snacks.notify.info("Closed " .. closed .. " terminal(s)")
          end
        end, kopts)

        vim.keymap.set("n", "a", function()
          close_win()
          vim.cmd("redraw")
          local answer = vim.fn.input("Close all " .. #items .. " terminal(s)? [y/N]: ")
          if answer:lower() == "y" then
            for _, item in ipairs(items) do
              item.term:close()
            end
            Snacks.notify.info("Closed all " .. #items .. " terminal(s)")
          end
        end, kopts)

        vim.keymap.set("n", "q", close_win, kopts)
        vim.keymap.set("n", "<esc>", close_win, kopts)
      end,
      desc = "List/Close Terminals",
    },
  },
}
