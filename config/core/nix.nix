{ lib, mkKey, specObj, pkgs, ... }:
let
  inherit (mkKey) mkKeymap;
in
with lib;
{
  plugins = {
    conform-nvim.enable = mkDefault true;
    conform-nvim.settings = {
      formatters_by_ft = {
        nix = [ "nixfmt" ];
      };
      formatters = {
        nixfmt = { command = lib.getExe pkgs.nixfmt-rfc-style; };
      };
    };
    lsp = {
      enable = mkDefault true;
      inlayHints = mkDefault true;
      servers.nil_ls = {
        enable = true;
        #settings.formatting.command = [ "${lib.getExe pkgs.nixfmt-rfc-style}" ];
      };
    };
  };

  extraConfigLua = # lua
    ''
      vim.keymap.set("n", "<leader>lf", function() require("conform").format() end, { noremap = true, silent = true, desc = "Format Buffer" })
      vim.keymap.set("v", "<leader>lf", function() require("conform").format() { async = true } end, { noremap = true, silent = true, desc = "Format Buffer" })
      vim.keymap.set("x", "<leader>lf", function() require("conform").format() { async = true } end, { noremap = true, silent = true, desc = "Format Buffer" })

    '';

  wKeyList = [
    (specObj [ "<leader>l" "󰿘" "lsp" ])
  ];
}
