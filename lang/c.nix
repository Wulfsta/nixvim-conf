{
  plugins.lsp.servers = {
    ccls = {
      enable = true;
      filetypes = [
        "c"
        "cpp"
        "objc"
        "objcpp"
      ];

      initOptions.compilationDatabaseDirectory = "build";
    };

    # TODO: see what further configuration might be needed
    cmake = {
      enable = true;
      filetypes = [ "cmake" ];
    };

    clangd = {
      enable = true;
      filetypes = [
        "c"
        "cpp"
        "objc"
        "objcpp"
      ];
    };
  };
}
