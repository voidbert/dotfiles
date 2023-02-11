-- Plugins
require 'paq' {
	{ 'tomasiser/vim-code-dark' };

	{ 'windwp/nvim-ts-autotag' }; -- Auto-close HTML
	{ 'nvim-treesitter/nvim-treesitter', run = function() vim.cmd('TSUpdate') end };

	-- LSP temporarily disabled (I don't feel the need for it with the type of code I deal with)
	-- { 'neovim/nvim-lspconfig' };
	-- { 'ms-jpq/coq_nvim' };
}

-- Line numbers
vim.wo.number = true
vim.wo.numberwidth = 6
vim.wo.cursorline = true

-- Indentation (convert tabs to spaces for some languages)
indent_callback = function ()
	vim.bo.tabstop = 6
	vim.bo.shiftwidth = 6

	local extension = vim.fn['expand']("%:e")
	if extension == 'hs' then
		vim.bo.expandtab = true
	else
		vim.bo.expandtab = false
	end
end
vim.api.nvim_create_autocmd('BufEnter', { callback = indent_callback })

-- Highlight trailing whitespaces
vim.api.nvim_create_autocmd('BufWinEnter', {
	callback = function()
		vim.api.nvim_set_hl(0, 'TrailingWhitespace', { ctermbg = 9 })
		vim.fn['matchadd']('TrailingWhitespace', '\\s\\+$')
	end
})

vim.g.lazyredraw = true           -- Performance
vim.opt.mouse = ''                -- Disable mouse (to see if you finally learn this for once)
vim.wo.colorcolumn = '100'        -- Column limit

-- Clipboard synchronization for non-Termux systems (termux-(get/set)-clipboard is slow)
vim.loop.spawn('sh', { args = { '-c', 'command -v termux-clipboard-get' } },
vim.schedule_wrap(function(code)
	if code == 0 then
		-- Termux: only get / set the system clipboard when requested

		vim.api.nvim_create_user_command('SystemClipboardSet', function()
			local cb = vim.fn['getreg']('')
			cb_set_handle = vim.loop.spawn('termux-clipboard-set', { args = { cb } },
				function()

				print('System clipboard set')
				cb_set_handle:close()
			end)
		end, {})

		vim.api.nvim_create_user_command('SystemClipboardGet', function()
			local pipe = vim.loop.new_pipe()
			cb_get_data = ''

			cb_get_handle = vim.loop.spawn('termux-clipboard-get',
				{ stdio = { nil, pipe, nil } }, vim.schedule_wrap(function()

				vim.loop.read_stop(pipe)
				vim.loop.close(pipe)

				vim.fn['setreg']('', cb_get_data)
				cb_get_data = ''

				print('Neovim\'s clipboard set')
				cb_get_handle:close()
			end))

			vim.loop.read_start(pipe, function(err, data)
				if data then
					cb_get_data = cb_get_data .. data
				else
					print(cb_get_data)
				end
			end)
		end, {})
	else
		vim.opt.clipboard = 'unnamedplus'
	end
end))

-- Syntax highlighting
require 'nvim-treesitter.configs'.setup {
	ensure_installed = {
		'c', 'cpp', 'make',
		'haskell',
		'python',
		'html', 'css', 'javascript', 'typescript',
		'json',

		'lua', 'help', -- For nvim
		'gitcommit', 'git_rebase', 'comment' -- For maintenance
	},

	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
	},

	indent = {
		enable = true
	},

	-- Automatically close HTML & XML tags
	autotag = {
		enable = true,
		filetypes = { "html" , "xml" }
	}
}
vim.g.termguicolors = true
vim.cmd('colorscheme codedark')

-- Folding
vim.wo.foldenable      = true
vim.wo.foldmethod      = 'expr'
vim.wo.foldexpr        = 'nvim_treesitter#foldexpr()'
vim.opt.foldlevelstart = 99

-- Spell check (only for text-like files)
vim.api.nvim_create_autocmd('BufWinEnter', { callback = function()
	vim.bo.spelllang = 'en'
end })
vim.api.nvim_create_autocmd('BufEnter', { callback = function()
	local extension = vim.fn['expand']("%:e")
	if extension == ''    or
	   extension == 'txt' or
	   extension == 'md'  or
	   extension == 'tex' or
	   extension == 'html'
	then
		vim.wo.spell = true
	else
		vim.wo.spell = false
	end
end })

-- LaTeX (asynchronous)
function compileLatex()
	local path = vim.api.nvim_buf_get_name(0)
	local pwd =  vim.fn['expand']('%:p:h')
	latex_handle = vim.loop.spawn('bash',
		{ args = { os.getenv('HOME') .. '/.config/nvim/latex.sh', path }, cwd = pwd },
		vim.schedule_wrap(function(code)

		if code == 0 then
			print('Compiled successfully')
		else
			vim.cmd('tab sview /tmp/nvim-latex/output')
		end
		latex_handle:close()
	end))
end

vim.api.nvim_create_autocmd('BufWritePost', { callback = compileLatex, pattern = '*.tex'})
vim.api.nvim_create_autocmd('BufWinEnter',  { callback = function()
	vim.api.nvim_buf_create_user_command(0, "Zathura", function()
		local pdf = '/tmp/nvim-latex/' .. vim.fn['expand']('%:t:r') .. '.pdf'
		local zathura = io.popen('zathura --fork "' .. pdf .. '"')
		zathura:close()
	end, {})
end, pattern = '*.tex' })

-- LSP
--[[
local lsp = require 'lspconfig'
local coq = require 'coq'

lsp['pyright'].setup(coq.lsp_ensure_capabilities({}))
lsp['hls'].setup(coq.lsp_ensure_capabilities({}))
lsp['clangd'].setup(coq.lsp_ensure_capabilities({}))
--]]

-- Future ideas:
--   Debugging
