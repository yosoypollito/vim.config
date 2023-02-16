require("nvim-tree").setup({
		actions={
			open_file={
				quit_on_open=true
			}
		},
		view={
			mappings={
				list = {
					{key = 's', action = "vsplit"},
					{key = './', action = "system_open"},
					{key = 'u', action = "dir_up"},
					{key = 'C', action = "cd"},
					{key = 'I', action = "toggle_dotfiles"},
					{key = 'H', action = "toggle_git_ignored"}
				}
			}
		}
	})
