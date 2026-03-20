{ lib, pkgs, ... }:
{
  plugins = {
    lsp.servers = {
      wgsl_analyzer = {
        enable = true;

        filetypes = [
          "wgsl"
          "wesl"
        ];

      };
    };
    conform-nvim.settings = {
      formatters_by_ft = {
        wgsl = [ "wgsl_analyzer" ];
        wesl = [ "wgsl_analyzer" ];
      };
    };
  };
}
