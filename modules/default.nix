{
  flake.nvixModules = {
    utils = ./utils; # Contains utility functions

    git = ./git;
    lsp = ./lsp;
    cmp = ./cmp;
    tex = ./tex;
    lang = ./lang;
    snacks = ./snacks;
    buffer = ./buffer; # Buffer manager/bufferline
    general = ./general; # General Neovim config
    lualine = ./lualine;
    explorer = ./explorer;
    dashboard = ./dashboard;
    aesthetics = ./aesthetics;
    treesitter = ./treesitter;
    auto-session = ./auto-session;
    colorschemes = ./colorschemes;
  };
}
