{ lib, pkgs, ... }:
{
  plugins = {
    lsp.servers = {
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
    conform-nvim.settings = {
      formatters_by_ft = {
        c = [ "clang_format" ];
        cmake = [ "cmake-format" ];
        cpp = [ "clang_format" ];
      };
      formatters = {
        cmake-format = {
          command = lib.getExe pkgs.cmake-format;
        };
      };
    };
  };
}
