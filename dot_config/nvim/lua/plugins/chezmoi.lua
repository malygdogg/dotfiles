return {
  {
    "xvzc/chezmoi.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      edit = {
        watch = false,
        force = false,
      },
      notification = {
        on_open = false,
        on_apply = false,
        on_watch = false,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = { os.getenv("HOME") .. "/*" },
        callback = function(ev)
          local source_dir = vim.fn.expand("~/.local/share/chezmoi/")
          if ev.match:find(source_dir, 1, true) then
            return
          end
          local source_path = vim.fn.system(
            "chezmoi source-path " .. vim.fn.shellescape(ev.match) .. " 2>/dev/null"
          ):gsub("\n", "")
          if source_path ~= "" and vim.fn.filereadable(source_path) == 1 then
            local buf = ev.buf
            vim.schedule(function()
              vim.cmd("edit " .. vim.fn.fnameescape(source_path))
              vim.api.nvim_buf_delete(buf, { force = true })
            end)
          end
        end,
      })
    end,
  },
}
