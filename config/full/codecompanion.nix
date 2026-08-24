{ specObj, pkgs, ... }:
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
        };
        opts = {
          #log_level = "TRACE";
          send_code = true;
          use_default_actions = true;
          use_default_prompts = true;
        };
        strategies = {
          agent = {
            adapter = "llama";
          };
          chat = {
            adapter = "llama";
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
