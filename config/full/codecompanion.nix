{
  specObj,
  pkgs,
  lib,
  ...
}:
let
  opencodeExe = lib.getExe pkgs.opencode;

  opencodeConfig = pkgs.writeText "opencode-config.json" (
    builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      provider.llamacpp = {
        npm = "@ai-sdk/openai-compatible";
        options.baseURL = "http://127.0.0.1:8000/v1";
        models.local = { };
      };
      model = "llamacpp/local";
    }
  );
in
{
  plugins = {
    codecompanion = {
      enable = true;
      settings = {
        adapters = {
          http = {
            llama = {
              __raw = ''
                function()
                  return require("codecompanion.adapters").extend("openai_compatible", {
                    env = {
                      url = "http://127.0.0.1:8000", -- replace with your llama.cpp instance
                      api_key = "TERM",
                      chat_url = "/v1/chat/completions",
                    },
                    handlers = {
                      parse_message_meta = function(self, data)
                        local extra = data.extra
                        if extra and extra.reasoning_content then
                          data.output.reasoning = { content = extra.reasoning_content }
                          if data.output.content == "" then
                            data.output.content = nil
                          end
                        end
                        return data
                      end,
                    },
                  })
                end
              '';
            };
          };
          acp = {
            opencode = {
              __raw = ''
                function()
                  local cwd = vim.fn.getcwd()
                  return require("codecompanion.adapters").extend("opencode", {
                    commands = {
                      default = {
                        "systemd-run", "--user", "--pipe", "--collect", "--quiet",
                        "--setenv=OPENCODE_CONFIG=${opencodeConfig}",
                        "--setenv=HOME=/tmp/home",
                        "-p", "ProtectSystem=strict",
                        "-p", "ProtectHome=tmpfs",
                        "-p", "PrivateTmp=yes",
                        "-p", "InaccessiblePaths=/var",
                        "-p", "NoNewPrivileges=yes",
                        "-p", "PrivateDevices=yes",
                        "-p", "ProtectKernelTunables=yes",
                        "-p", "ProtectKernelModules=yes",
                        "-p", "ProtectControlGroups=yes",
                        "-p", "BindPaths=" .. cwd,
                        "--",
                        "${opencodeExe}", "acp",
                      },
                    },
                  })
                end
              '';
            };
          };
        };
        opts = {
          #log_level = "TRACE";
          send_code = true;
          use_default_actions = true;
          use_default_prompts = true;
        };
        strategies = {
          agent = {
            adapter = "opencode";
          };
          chat = {
            adapter = "opencode";
          };
          inline = {
            adapter = "llama";
          };
        };
      };
    };
  };

  globals = {
  };

  wKeyList = [
  ];
}
