local float = require("user.defaults").diagnostics_options.float

return {
	{
		"neovim/nvim-lspconfig",
		ft = { "lua", "c", "cpp" },
		dependencies = {
			"williamboman/mason.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"j-hui/fidget.nvim",
			{
				"ray-x/lsp_signature.nvim",
				opts = {
					bind = true,
					max_height = float.max_height,
					max_width = float.max_width,
					hint_inline = function()
						return vim.version.gt(vim.version(), { 0, 9, 0 })
					end,
					handler_opts = {
						border = float.border,
					},
				},
			},
		},
		config = function()
			local capabilities =
				require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

			local on_attach = function(client, bufnr)
				_ = client
				_ = bufnr
				require("lspconfig.ui.windows").default_options = {
					border = float.border,
				}
			end

			-- Configure lua_ls
			vim.lsp.config("lua_ls", {
				on_attach = on_attach,
				capabilities = capabilities,
				cmd = {
					"lua-language-server",
					"-E",
					"/usr/share/lua-language-server/main.lua",
				},
				on_init = function(client)
					if client.workspace_folders then
						local path = client.workspace_folders[1].name
						if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
							return
						end
					end
				end,
				settings = {
					Lua = {
						runtime = {
							-- LuaJIT in the case of Neovim
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							library = { vim.env.VIMRUNTIME },
							-- This feature causes the lsp to use the "environment emulation" feature to suggest
							-- applying a library/framework when a certain keyword or filename has been found
							checkThirdParty = false,
						},
						-- disable lua_ls default formater since I use stylua
						format = { enable = false },
						hint = { enable = true, setType = true },
						telemetry = { enable = false },
					},
				},
			})

			-- Configure clangd
			vim.lsp.config("clangd", {
				on_attach = on_attach,
				capabilities = capabilities,
			})

			-- Enable the LSP servers
			vim.lsp.enable("lua_ls")
			vim.lsp.enable("clangd")
		end,
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		opts = {
			ui = {
				border = float.border,
			},
			outline = {
				layout = "float",
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = function()
			local null_ls = require("null-ls")
			return {
				diagnostics_format = "#{m} (#{s})",
				sources = {
					-- cpp
					null_ls.builtins.diagnostics.cppcheck.with({
						extra_args = {
							"--inconclusive",
						},
					}),
					-- lua
					null_ls.builtins.diagnostics.selene,
					null_ls.builtins.formatting.stylua,
					-- php
					--null_ls.builtins.diagnostics.phpstan,
					--null_ls.builtins.formatting.phpcsfixer,
					-- shell
					null_ls.builtins.diagnostics.zsh.with({
						filetypes = { "zsh" },
					}),
					null_ls.builtins.hover.printenv.with({
						filetypes = { "zsh", "bash", "sh", "dosbatch", "ps1" },
					}),
					-- Docker
					-- null_ls.builtins.diagnostics.hadolint,
					-- opengl
					--null_ls.builtins.diagnostics.glslc.with({
					-- use opengl instead of vulkan1.0
					--	extra_args = { "--target-env=opengl" },
					--}),
				},
			}
		end,
	},
}
