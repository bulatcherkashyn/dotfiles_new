vim.opt.guicursor = ""

vim.opt.nu = true

--vim.opt.tabstop = 4
--vim.opt.softtabstop = 4
--vim.opt.shiftwidth = 4
--vim.opt.expandtab = false
--vim.opt.smartindent = true

vim.api.nvim_set_option("clipboard", "unnamed")

vim.o.tabstop = 4
vim.bo.tabstop = 4
vim.o.showtabline = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.bo.shiftwidth = 4
vim.o.smartindent = true
vim.bo.smartindent = true
vim.o.autoindent = true
vim.bo.autoindent = true
vim.o.expandtab = true
vim.bo.expandtab = true

vim.opt.wrap = true

vim.o.splitbelow = true
vim.o.splitright = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.keymap.set("", "<up>", "<nop>", { noremap = true })
vim.keymap.set("", "<down>", "<nop>", { noremap = true })
vim.keymap.set("i", "<up>", "<nop>", { noremap = true })
vim.keymap.set("i", "<down>", "<nop>", { noremap = true })
vim.opt.mouse = ""
vim.opt.mousescroll = "ver:0,hor:0"

vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

--vim.opt.foldmethod = "expr"
--vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--vim.opt.foldlevel = 99
--vim.opt.foldlevelstart = 1
--vim.opt.foldcolumn = "0"
--vim.opt.foldtext = ""
