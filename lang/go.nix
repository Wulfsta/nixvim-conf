{ lib, pkgs, ... }:
{
  plugins = {
    lsp.servers = {
      gopls = {
        enable = true;
        filetypes = [
          "go"
        ];
      };
    };
    conform-nvim.settings = {
      formatters_by_ft = {
        go = [ "gofmt" ];
      };
      formatters = {
        gofmt = { command = lib.getExe pkgs.go + " fmt"; };
      };
    };
  };
}
