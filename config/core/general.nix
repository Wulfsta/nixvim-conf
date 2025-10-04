{ icons, opts, ... }:
{

  performance.byteCompileLua = {
    enable = true;
    nvimRuntime = true;
  };

  plugins = {
    tmux-navigator.enable = true;
    web-devicons.enable = true;
    nvim-autopairs.enable = true;
  };
  extraConfigLua = # lua
    ''
      local signs = {
        Hint = "${icons.diagnostics.BoldHint}",
        Info = "${icons.diagnostics.BoldInformation}",
        Warn = "${icons.diagnostics.BoldWarning}",
        Error = "${icons.diagnostics.BoldError}",
      }

      vim.diagnostic.config({
        virtual_text = false,
        underline = true,
        signs = {
          text = {
            [vim.diagnostic.severity.HINT] = signs.Hint,
            [vim.diagnostic.severity.INFO] = signs.Info,
            [vim.diagnostic.severity.WARN] = signs.Warn,
            [vim.diagnostic.severity.ERROR] = signs.Error,
          },
        },
        severity_sort = true,
        float = {
          border = "${opts.border}",
          source = "always",
          focusable = false,
        },
      })
    '';
}
