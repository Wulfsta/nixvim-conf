{
  plugins = {
    ts-autotag.enable = true;
    ts-comments.enable = true;
    lsp.servers = {
      ts_ls.enable = true;
      tailwindcss = {
        enable = true;
        filetypes = [
          "html"
          "css"
          "scss"
          "less"
          "javascript"
          "javascriptreact"
          "typescript"
          "typescriptreact"
          "vue"
          "svelte"
        ];
      };
      svelte.enable = true;
      jsonls.enable = true;
      html.enable = true;
      eslint.enable = true;
      emmet_ls.enable = true;
      cssls.enable = true;
      biome.enable = true;
    };
  };
}
