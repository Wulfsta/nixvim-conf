# This file contains plugins that are basics or don't need their own file
{
  inputs,
  mkPkgs,
  mkKey,
  ...
}:
let
  inherit (mkKey) mkKeymap;
in
{
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
