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
  };
}
