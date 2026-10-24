{
  plugins = {
    treesitter = {
      enable = true;
      highlight = {
        enable = true;
        disable = [
          "latex"
        ];
      };
      settings = {
        auto_install = true;
        incremental_selection.enable = true;
        indent.enable = true;
      };
    };
    treesitter-textobjects = {
      enable = true;
    };
    mini.enable = true;
    indent-blankline = {
      enable = true;
      settings = {
        indent.char = "│";
        exclude.filetypes = [
          "''"
          "lspinfo"
          "dashboard"
          "checkhealth"
        ];
      };
    };
  };
  extraConfigLua = ''
    require('mini.indentscope').setup({
      symbol = "│",
    })

    -- Stop treesitter highlighter in buffer on chat open.
    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionChatOpened',
      group = vim.api.nvim_create_augroup('TSChatNoHighlight', { clear = true }),
      callback = function(ev)
        local buf = (ev.data and ev.data.bufnr) or vim.api.nvim_get_current_buf()
        vim.schedule(function()
          pcall(vim.treesitter.stop, buf)
        end)
      end,
    })
  '';
}
