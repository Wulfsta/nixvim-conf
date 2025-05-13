# This file contains plugins that are basics or don't need their own file
{
  pkgs,
  mkKey,
  ...
}:
let
  inherit (mkKey) mkKeymap;
in
{
  # Keeping this at top so that if any plugin is removed it's respective config can be removed
  extraConfigLua = # lua
    ''
      require("windows").setup()
    '';
  keymaps = [ (mkKeymap "n" "<c-w>=" "<cmd>WindowsEqualize<CR>" "Equalize windows") ];
  extraPlugins = [
    pkgs.vimPlugins.windows-nvim
  ];
  plugins = {

    # TODO: add multicursor

    neoscroll.enable = true;
    trim.enable = true;
    nvim-surround.enable = true;
    dressing.enable = true;
    lastplace.enable = true;
    oil.enable = true;

    fidget = {
      enable = true;
      settings = {
        progress.display.progressIcon.pattern = "moon";
        notification.window = {
          relative = "editor";
          winblend = 0;
          border = "none";
        };
      };
    };
  };
}
