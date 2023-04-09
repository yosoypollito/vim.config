local function open_nvim_tree(data)

  -- buffer is a directory
  local directory = vim.fn.isdirectory(data.file) == 1

  if not directory then
    return
  end

  -- change to the directory
  vim.cmd.cd(data.file)

  -- open the tree
  require("nvim-tree.api").tree.open()
end

vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })

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
