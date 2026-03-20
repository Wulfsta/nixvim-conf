{
  mkKey,
  mkPkgs,
  icons,
  specObj,
  inputs,
  pkgs,
  lib,
  ...
}:
let
  inherit (mkKey) mkKeymap;
in
{
  wKeyList = [
    (specObj [
      "<leader>e"
      ""
    ])
  ];

  extraPlugins = [
    (mkPkgs "nvim-window-picker" inputs.nvim-window-picker)
  ];

  extraConfigLua = ''
    require('window-picker').setup({
      hint = 'floating-big-letter'
    })
  '';

  extraPackages = with pkgs; [ gcc ];

  plugins.neo-tree = {
    enable = true;

    settings = {
      sources = [
        "filesystem"
        "buffers"
        "git_status"
        "document_symbols"
      ];
      source_selector.winbar = true;
      use_popups_for_input = false;
      default_component_configs = {
        diagnostics.symbols = {
          hint = "${icons.diagnostics.BoldHint}";
          info = "${icons.diagnostics.BoldInformation}";
          warn = "${icons.diagnostics.BoldWarning}";
          error = "${icons.diagnostics.BoldError}";
        };
        git_status.symbols = {
          unstaged = "${icons.git.FileUnstaged}";
          staged = "${icons.git.FileStaged}";
          renamed = "${icons.git.FileRenamed}";
          untracked = "${icons.git.FileUntracked}";
          deleted = "${icons.git.FileDeleted}";
          ignored = "${icons.git.FileIgnored}";
        };
      };
      buffers.follow_current_file.enabled = true;
      defaultComponentConfigs = {
        diagnostics.symbols = {
          hint = "${icons.diagnostics.BoldHint}";
          info = "${icons.diagnostics.BoldInformation}";
          warn = "${icons.diagnostics.BoldWarning}";
          error = "${icons.diagnostics.BoldError}";
        };
        gitStatus.symbols = {
          unstaged = "${icons.git.FileUnstaged}";
          staged = "${icons.git.FileStaged}";
          renamed = "${icons.git.FileRenamed}";
          untracked = "${icons.git.FileUntracked}";
          deleted = "${icons.git.FileDeleted}";
          ignored = "${icons.git.FileIgnored}";
        };
      };
      filesystem.window.mappings."F" = "fuzzy_finder_directory";
      window = {
        position = "right";
        autoExpandWidth = true;
        mappings = {
          "s" = "open_split";
          "v" = "open_vsplit";
          "l" = "open_with_window_picker";
          "<cr>" = "open_with_window_picker";
          "<C-d>" = {
            command = "scroll_preview";
            config.direction = -10;
          };
          "<C-u>" = {
            command = "scroll_preview";
            config.direction = 10;
          };
          "<space>" = "none";
          "K" = "focus_preview";
          "P" = {
            command = "toggle_preview";
            config.use_float = true;
          };
        };
      };
    };
  };
  keymaps = [
    (mkKeymap "n" "<leader>e" (lib.nixvim.mkRaw # lua
      ''
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end
      ''
    ) "Explorer NeoTree (cwd)")
  ];
}
