{ pkgs, mkKey, ... }:
let
  inherit (mkKey) mkKeymap;
in
{

  extraPlugins = [
    pkgs.vimPlugins.nvzone-minty
  ];
  extraConfigLua = # lua
    ''
      require('minty').setup({
        huefy = {
          mappings = function(buf)
              local api = require("minty.shades.api")
              vim.keymap.set("n", "s", api.save_color, { buffer = buf })
            end
        };
      })
    '';

  plugins.colorizer = {
    enable = true;
    settings.userDefaultOptions = {
      css = true;
      mode = "virtualtext";
      tailwind = true;
      sass.enable = true;
      virtualtext = "■";
    };
  };

  keymaps = [
    (mkKeymap "n" "<leader>uc" "<cmd>lua require('minty.huefy').open()<cr>" "Color Picker (minty)")
  ];
}
