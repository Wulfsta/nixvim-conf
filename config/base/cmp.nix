{ opts, lib, ... }:
{
  highlightOverride = {
    PMenu = {
      ctermbg = "none";
      bg = "none";
    };
  };
  # colorschemes.rose-pine.enable = true;
  plugins = {
    lspkind.enable = true;
    luasnip.enable = true;

    cmp_luasnip.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        snippet.expand = # lua
          ''
            function(args)
              require("luasnip").lsp_expand(args.body)
            end
          '';
        window = {
          documentation.border = "${opts.border}";
          completion = {
            border = "${opts.border}";
            scrollbar = false;
          };
        };
        sources = [
          { name = "cmp_luasnip"; }
          { name = "luasnip"; }
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "path"; }
          {
            name = "buffer";
            option = {
              get_bufnrs = lib.nixvim.mkRaw ''
                function()
                  local bufs = {}
                  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                    if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "codecompanion" then
                      table.insert(bufs, buf)
                    end
                  end
                  return bufs
                end
              '';
            };
          }
        ];
        mapping = (
          lib.nixvim.mkRaw # lua
            ''
              cmp.mapping.preset.insert({
                ["<C-k>"] = cmp.mapping.select_prev_item(),
                ["<C-j>"] = cmp.mapping.select_next_item(),

                ["<c-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                ["<c-d>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),

                ["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),

                ["<c-CR>"] = cmp.mapping.confirm({
                  behavior = cmp.ConfirmBehavior.Insert,
                  select = true,
                }),

                ["<CR>"] = cmp.mapping({
                  i = function(fallback)
                    fallback()
                  end,
                }),

                ["<c-h>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
                  else
                    fallback()
                  end
                end, { "i", "s" }),

                ["<c-l>"] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
                  else
                    fallback()
                  end
                end, { "i", "s" }),
              })
            ''
        );
      };
    };
  };

}
