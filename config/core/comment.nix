{ mkKey, lib, ... }:
let
  inherit (mkKey) mkKeymap;
in
{
  plugins.comment.enable = true;
  keymaps = [
    (mkKeymap "n" "<leader>/"
      (lib.nixvim.mkRaw ''function() require("Comment.api").toggle.linewise.current() end'')
      "Toggle comment"
    )
    (mkKeymap "v" "<leader>/"
      "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>"
      "Toggle comment"
    )
  ];
}
