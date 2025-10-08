{ lib, pkgs, ... }:
{
  plugins = {
    lsp.servers = {
      taplo = {
        enable = true;
        filetypes = [
          "toml"
        ];
      };
    };
    conform-nvim.settings = {
      formatters_by_ft = {
        toml = [ "taplo" ];
      };
      formatters = {
        taplo = {
          command = lib.getExe pkgs.taplo + " format";
        };
      };
    };
  };
}
