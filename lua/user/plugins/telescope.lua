local function is_git_repo()
	vim.fn.system("git rev-parse --is-inside-work-tree")
	--@diagnostic disable-next-line: undefined-field
	return vim.v.shell_error == 0
end

local telescope_builtin = function(builtin, opts)
	local params = { builtin = builtin, opts = opts or {} }

	return function()
		builtin = params.builtin
		opts = params.opts
		if builtin == "files" then
			if is_git_repo() then
				opts.show_untracked = true
				builtin = "git_files"
			else
				builtin = "find_files"
			end
		elseif builtin == "live_grep" then
			local function get_git_root()
				local dot_git_path = vim.fn.finddir(".git", ".;")
				return vim.fn.fnamemodify(dot_git_path, ":h")
			end

			if is_git_repo() then
				opts.cwd = get_git_root()
			end
		end
		require("telescope.builtin")[builtin](opts)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	cmd = "Telescope",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	keys = {
		{
			"<leader>,",
			telescope_builtin("buffers", { show_all_buffers = true }),
			desc = "Switch buffer",
		},
		{
			"<leader>fb",
			telescope_builtin("buffers"),
			desc = "Find buffers",
		},
		{
			"<leader>:",
			telescope_builtin("command_history"),
			desc = "Command history",
		},
		-- find
		{
			"<leader><space>",
			telescope_builtin("files"),
			desc = "Find files (root dir)",
		},
		{
			"<leader>ff",
			telescope_builtin("files"),
			desc = "Find files (root dir)",
		},
		{
			"<leader>fr",
			telescope_builtin("oldfiles"),
			desc = "Recent",
		},
		-- git
		{ "<leader>gc", telescope_builtin("git_commits"), desc = "Commits" },
		{ "<leader>gs", telescope_builtin("git_status"), desc = "Status" },
		-- search
		{ "<leader>sa", telescope_builtin("autocommands"), desc = "Auto commands" },
		{ "<leader>sc", telescope_builtin("command_history"), desc = "Command history" },
		{
			"<leader>sC",
			telescope_builtin("commands"),
			desc = "Commands",
		},
		{
			"<leader>/",
			telescope_builtin("live_grep"),
			desc = "Find in files (grep)",
		},
		{
			"<leader>sg",
			telescope_builtin("live_grep"),
			desc = "Grep (root dir)",
		},
		{
			"<leader>sh",
			telescope_builtin("help_tags"),
			desc = "Help pages",
		},
		{
			"<leader>sH",
		},
		{
			"<leader>sb",
			telescope_builtin("current_buffer_fuzzy_find"),
			function()
				telescope_builtin("current_buffer_fuzzy_find")(require("telescope.themes").get_dropdown({
					previewer = false,
				}))
			end,
			desc = "Find fuzzy match in current buffer",
		},
	},
	opts = function()
		local actions = require("telescope.actions")
		return {
			defaults = {
				mappings = {
					i = {
						["<C-n>"] = actions.cycle_history_next,
						["<C-p>"] = actions.cycle_history_prev,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
					n = { ["q"] = actions.close },
				},
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		}
	end,
	config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		telescope.load_extension("fzf")
	end,
}
