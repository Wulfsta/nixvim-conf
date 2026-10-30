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
        models.local = {
          limit = {
            # Inform OpenCode of the context size, since it seemingly does not read it from the models endpoint.
            context = 98304;
            output = 98304;
          };
        };
      };
      model = "llamacpp/local";
    }
  );

  opencodeCmd =
    if pkgs.stdenv.hostPlatform.isDarwin then
      ''
        local uv = vim.uv
        local cwd = uv.fs_realpath(vim.fn.getcwd())
        local conf = uv.fs_realpath((vim.env.XDG_CONFIG_HOME or (vim.env.HOME .. "/.config")) .. "/opencode")
          or "/var/empty"
        local scratch = vim.fn.tempname() -- throwaway $HOME, deleted when nvim exits
        vim.fn.mkdir(scratch .. "/.config/opencode", "p")
        scratch = uv.fs_realpath(scratch)
        local own = { node_modules = true, ["package.json"] = true, ["bun.lock"] = true, [".gitignore"] = true }
        for name in vim.fs.dir(conf) do
          if not own[name] then
            uv.fs_symlink(conf .. "/" .. name, scratch .. "/.config/opencode/" .. name)
          end
        end
        local cmd = {
          "/usr/bin/sandbox-exec",
          "-D", "CWD=" .. cwd, "-D", "SCRATCH=" .. scratch, "-D", "CONFIG=" .. conf,
          "-p", [[
            (version 1)
            (allow default)
            (deny file-write*)
            (deny file-read-data file-read-xattr
              (subpath "/Users") (subpath "/Volumes")
              (subpath "/private/tmp") (subpath "/private/var/folders"))
            (allow file-read-data file-read-xattr
              (subpath (param "CWD")) (subpath (param "SCRATCH")) (subpath (param "CONFIG")))
            (allow file-write* (subpath (param "CWD")) (subpath (param "SCRATCH")))
            (allow file-write* (literal "/dev/null") (literal "/dev/zero") (literal "/dev/dtracehelper")
              (regex #"^/dev/fd/"))
            (deny network-outbound (remote unix-socket))
            (allow network-outbound (remote unix-socket (path-literal "/private/var/run/mDNSResponder")))
            (allow network-outbound (remote unix-socket (path-literal "/nix/var/nix/daemon-socket/socket")))
          ]],
          "/usr/bin/env", "-i", "HOME=" .. scratch, "TMPDIR=" .. scratch,
        }
        for _, k in ipairs({ "PATH", "NIX_SSL_CERT_FILE", "LANG", "ANTHROPIC_API_KEY" }) do
          if vim.env[k] then table.insert(cmd, k .. "=" .. vim.env[k]) end
        end
        vim.list_extend(cmd, { "${opencodeExe}", "acp" })
      ''
    else
      ''
        local cwd = vim.fn.shellescape(vim.fn.getcwd())
        local cmd = {
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
        }
      '';
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
                      url = "http://127.0.0.1:8000",
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
                  ${opencodeCmd}
                  return require("codecompanion.adapters").extend("opencode", {
                    commands = { default = cmd },
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
          context_management = {
            editing = {
              trigger = 0.65;
            };
            compaction = {
              trigger = 0.85;
            };
          };
        };
        strategies = {
          agent = {
            adapter = "opencode";
          };
          chat = {
            adapter = "opencode";
          };
          inline = {
            adapter = if pkgs.stdenv.hostPlatform.isDarwin then "opencode" else "llama";
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
