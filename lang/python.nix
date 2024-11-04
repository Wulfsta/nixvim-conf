{ lib, pkgs, ... }:
{
  plugins = {
    lsp.servers = {
      ruff.enable = true;
      pyright = {
        enable = true;
        settings = {
          pyright.disableOrganizeImports = true;
          python.analysis.ignore = [ "*" ];
        };
      };
    };
    conform-nvim.settings = {
      formatters_by_ft = {
        python = [ "isort" "ruff" ];
      };
      formatters = {
        isort = { command = lib.getExe pkgs.isort; };
        ruff = { command = lib.getExe pkgs.ruff; };
      };
    };
  };
}
