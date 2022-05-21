local o = vim.opt

o.backup = false -- creates a backup file
o.swapfile = false -- enable/disable swap file creation
o.clipboard = "unnamedplus" -- allows neovim to access the system clipboard
o.fileencoding = "utf-8" -- the encoding written to a file
o.expandtab = true -- convert tabs to spaces
o.shiftwidth = 2 -- the number of spaces inserted for each indentation
o.tabstop = 2 -- how many columns a tab counts for
o.termguicolors = true -- set term gui colors (most terminals support this)

o.wildmode = "full"
o.lazyredraw = true -- do not redraw screen while running macros
o.grepprg = "rg --hidden --vimgrep --smart-case --"
o.completeopt = { "menu", "menuone", "noselect", "noinsert" } -- A comma separated list of options for Insert mode completion
o.wildignorecase = true -- When set case is ignored when completing file names and directories
o.wildignore = [[
.git,.hg,.svn
*.aux,*.out,*.toc
*.o,*.obj,*.exe,*.dll,*.manifest,*.rbc,*.class
*.ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp
*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg
*.mp3,*.oga,*.ogg,*.wav,*.flac
*.eot,*.otf,*.ttf,*.woff
*.doc,*.pdf,*.cbr,*.cbz
*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb
*.swp,.lock,.DS_Store,._*
*.pyc,**/__pycache__/**
*/tmp/*,*.so,*.swp,*.zip,**/node_modules/**,**/target/**,**.terraform/**"
]]
