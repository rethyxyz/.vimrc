"-----------"
" FUNCTIONS "
"-----------"

function MakeDirectory(directory)
	if !isdirectory(a:directory)
		call mkdir(a:directory)
		call Log("mkdir " . a:directory)
	endif
endfunction

function! Log(message)
	echom ".vimrc: " . a:message
endfunction

function! WrapLine(sTagOpen, sTagClose)
    execute "normal! I" . a:sTagOpen . "\<esc>A" . a:sTagClose . "\<esc>0wwl\<esc>"
endfunction

function! InsertTag(tag)
    execute "normal i" . a:tag . "\<esc>"
endfunction

function! RemoveTagOverCursor()
    execute "normal! vit\"+c\<esc>ddO\<esc>\"+p"
endfunction

function! FontSizePlus()
	let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
	let l:gf_size_whole = l:gf_size_whole + 1
	let l:new_font_size = ':h'.l:gf_size_whole
	let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
endfunction

function! FontSizeMinus()
	let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
	let l:gf_size_whole = l:gf_size_whole - 1
	let l:new_font_size = ':h'.l:gf_size_whole
	let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
endfunction

function! StartScreen()
	" Don't run this function if the following:
	"     1. Command line arguments.
	"     2. Starting buffer is not empty.
	"	  3. Vim wasn't invoked using the vim or gvim command.
	"	  4. We start in insert mode>
    if argc() || line2byte('$') != -1 || v:progname !~? '^[-gmnq]\=vim\=x\=\%[\.exe]$' || &insertmode
        return
    endif

	" Create a new buffer.
    enew

    " Add options to local buffer.
    setlocal
        \ bufhidden=wipe
        \ buftype=nofile
        \ nobuflisted
        \ nocursorcolumn
        \ nocursorline
        \ nolist
        \ nonumber
        \ noswapfile
        \ norelativenumber

    for line in g:motd
        call append('$', l:line)
    endfor

    " No modifications to this buffer
    setlocal nomodifiable nomodified

    " When we go to insert mode start a new buffer, and start insert
    nnoremap <buffer><silent> e :enew<CR>
    nnoremap <buffer><silent> i :enew <bar> startinsert<CR>
    nnoremap <buffer><silent> o :enew <bar> startinsert<CR>
    nnoremap <buffer><silent> q :q!<CR>
    nnoremap <buffer><silent> gh :exec "e " . g:projects<CR>
endfun



"-----------"
" CONSTANTS "
"-----------"

let pathogenFilepath = $HOME . "/vimfiles/autoload/pathogen.vim"
let defaultFilepath = $HOME . "/defaults.vim"
let abbreviationsFilepath = $HOME . "/abbreviations.vim"
" TODO: Narrow these down into a single file. These two separate ones are
" redundant.
let mapsFilepath = $HOME . "/maps.vim"
let movementsFilepath = $HOME . "/movements.vim"

let lines = 40
let columns = 100

let colorscheme = "peachpuff"

let mapleader = " "

" Windows specific defaults.
let defaultWindowsFont = "Lucida\\ Console"
let defaultWindowsFontSize = "10"
" This is actually explorer.exe, but it's vim's way of opening it.
let defaultWindowsExplorer = "start"
let defaultWindowsWebBrowser = "C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe"
let defaultWindowsVSCodeCommand = "code.cmd"
" Default directories.
let defaultWindowsVimDirectory = $HOME . "/vimfiles"
let defaultWindowsProjectsDirectory = $HOME . "/OneDrive/Projects"
let defaultWindowsNotesDirectory = $HOME . "/Documents/Notes"
let defaultWindowsDownloadsDirectory = $HOME . "/Downloads"
let defaultWindowsDocumentsDirectory = $HOME . "/Documents"
let defaultWindowsMusicDirectory = $HOME . "/Music"
let defaultWindowsVideosDirectory = $HOME . "/Videos"

" Linux specific defaults.
let defaultUnixFont = "monospace"
let defaultUnixFontSize = "10"
let defaultUnixExplorer = "ranger"
let defaultUnixWebBrowser = "firefox"
let defaultUnixVSCodeCommand = "code"
" Default directories.
let defaultUnixVimDirectory = $HOME . "/.vim"
let defaultUnixProjectsDirectory = $HOME . "/Documents/Projects"
let defaultUnixNotesDirectory = $HOME . "/Documents/Notes"
let defaultUnixDownloadsDirectory = $HOME . "/Downloads"
let defaultUnixDocumentsDirectory = $HOME . "/Documents"
let defaultUnixMusicDirectory = $HOME . "/Music"
let defaultUnixVideosDirectory = $HOME . "/Videos"

" This is will be used for the start screen.
let motd = [
\"Brody Rethy (C) 2023",
\"https://github.com/rethyxyz/.vimrc",
\"",
\"gh: Open your projects directory.",
\"e:  Open empty buffer.",
\"i:  Open empty buffer in insert mode.",
\"o:  Open empty buffer in insert mode.",
\"q:  Quit.",
\"",
\]

" Source defaultFilepath. Overwrite duplicate declarations (if any).
if filereadable(defaultFilepath)
	exec "source " . g:defaultFilepath
	call Log("Sourced " . g:defaultFilepath . ".")
endif



"-----------------------------------"
" INITIALIZE GLOBAL STATE VARIABLES "
"-----------------------------------"

" os
if has("win32") || has("win16") || has("win64") || has("win95")
	let os = "windows"
elseif has("macunix") || has("unix") || has("win32unix")
	let os = "unix"
else
	let os = "unknown"
endif
call Log(g:os . " detected.")

" pathogenEnabled
if os == "windows" && filereadable(pathogenFilepath)
	let pathogenEnabled = 1
	call Log("vim-pathogen enabled.")
else 
	let pathogenEnabled = 0
endif

" guiEnabled
if has("gui_running")
	let guiEnabled = 1
	call Log("GUI detected.")
else 
	let guiEnabled = 0
endif



"--------------------"
" INITIALIZE OPTIONS "
"--------------------"

syntax on
syntax enable
filetype indent plugin on

" Auto indents to previous line's level after making new line
set autoindent

" Ignores search casing.
set ignorecase

" Enable backspace key in insert mode.
set backspace=indent,eol,start

" Disables annoying .swp files.
set noswapfile

" Allow / and \ to be using for autocomplete.
set shellslash

" Enable persistent undo history.
set undofile

" Set line and relative line numbering.
set relativenumber number

" Set tab, Shift + >, and indent spacing options.
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Set Windows/Unix directories.
if os == "windows"
	let font = g:defaultWindowsFont
	let fontSize = g:defaultWindowsFontSize

	let vimDirectory = g:defaultWindowsVimDirectory

	let webBrowser = g:defaultWindowsWebBrowser
	let fileExplorer = g:defaultWindowsExplorer
	let vscode = g:defaultWindowsVSCodeCommand

	let projects = g:defaultWindowsProjectsDirectory
	let notes = g:defaultWindowsNotesDirectory
	let downloads = g:defaultWindowsDownloadsDirectory
	let documents = g:defaultWindowsDocumentsDirectory
	let music = g:defaultWindowsMusicDirectory
	let videos = g:defaultWindowsVideosDirectory
elseif os == "unix"
	let font = g:defaultUnixFont
	let fontSize = g:defaultUnixFontSize

	let vimDirectory = g:defaultUnixVimDirectory

	let webBrowser = g:defaultUnixWebBrowser
	let fileExplorer = g:defaultUnixExplorer
	let vscode = g:defaultUnixVSCodeCommand

	let projects = g:defaultUnixProjectsDirectory
	let notes = g:defaultUnixNotesDirectory
	let downloads = g:defaultUnixDownloadsDirectory
	let documents = g:defaultUnixDocumentsDirectory
	let music = g:defaultUnixMusicDirectory
	let videos = g:defaultUnixVideosDirectory
endif

" Enable vim-pathogen.
if pathogenEnabled
	execute pathogen#infect()

	let g:vimwiki_list = [{'path': g:notes, 'syntax': 'markdown', 'ext': '.md'}]
endif

" GUI specific options.
if guiEnabled
	" Set window font and font size.
	exec "set guifont=" . g:font . ":h" . g:fontSize

	" Disable gVim menu items.
	set guioptions-=T
	set guioptions-=m
	set guioptions-=r

	" Set colorscheme.
	exec "colorscheme " . g:colorscheme

	" Set initial gVim window size.
	exec "set lines=" . g:lines . " columns=" . g:columns
endif

" Initialize vimfiles/... structure. These'll be created in the next step.
let autoloadDirectory = g:vimDirectory . "/autoload"
let bundleDirectory = g:vimDirectory . "/bundle"
let undoDirectory = g:vimDirectory . "/undodir"

" Set undodir.
exec "set undodir=" . g:undoDirectory

" TODO: Make this into an array
" Setup directory structure.
if !isdirectory(vimDirectory)
	call mkdir(vimDirectory)
endif
if !isdirectory(autoloadDirectory)
	call mkdir(autoloadDirectory)
endif
if !isdirectory(bundleDirectory)
	call mkdir(bundleDirectory)
endif
if !isdirectory(undoDirectory)
	call mkdir(undoDirectory)
endif



"----------------------"
" STANDARD KEYBINDINGS "
"----------------------"

map ; :

" Move between buffers left/down/up/right.
map <leader>h <C-W>h
map <leader>j <C-W>j
map <leader>k <C-W>k
map <leader>l <C-W>l

" Move buffers left/down/up/right.
map <leader>H <C-W>H
map <leader>J <C-W>J
map <leader>K <C-W>K
map <leader>L <C-W>L

" Resize buffer horizontally by +1/-1.
map <C-j> :resize +1<CR>
map <C-k> :resize -1<CR>

" Resize buffer vertically by +1/-1.
map <C-l> :vertical resize +1<CR>
map <C-h> :vertical resize -1<CR>

" Split buffer horizontally/vertically.
map <leader>s :split<CR>
map <leader>v :vsplit<CR>

" Enter netrw.
map <leader><leader> :Ex<CR>

" Additional { } keys.
nnoremap <S-h> {
nnoremap <S-l> }

" Toggle color column
map <leader>col :execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>

" Toggle horizontal and vertical lines (crosshair style).
map <leader>line :set cursorline! cursorcolumn!<CR>

" Insert date/time below cursor.
map <leader>date :put =strftime(\"%Y-%m-%d\")<CR>
map <leader>time "=strftime("%r")<CR>P

" Re-detect file type.
map <leader>ftd :filetype detect<CR>

" Go to next file in file list.
map <leader>n :next<CR>

" Write Quit/Quit/Write.
map <leader>wq :wq<CR>
map <leader>q :quit<CR>
map <leader>; :write<CR>

" Load current file/.vimrc.
nnoremap <leader>rf :source %<CR>
nnoremap <leader>rl :exec "source " . $HOME . "/.vimrc"<CR>

" Toggle English spell checker.
nnoremap <leader>sc :setlocal spell! spelllang=en_us<CR>

" Open file in browser/vscode/file explorer.
nnoremap <leader>openb :silent execute "!\"". g:webBrowser . "\" \"file:///%:p\""<CR>
nnoremap <leader>openv :silent execute "!". g:vscode . " \"%:p\""<CR>
nnoremap <leader>opend :silent execute "!" . g:fileExplorer . " " . getcwd()<CR>

" Toggle line numbering.
nnoremap <leader>num :set nonumber! norelativenumber!<CR>

" Font resize keybindings. Not needed for non-GUI.
if guiEnabled
	map <A-=> :call FontSizePlus()<CR>
	map <A--> :call FontSizeMinus()<CR>
	map <A-+> :exec "set guifont=" . g:font . ":h" . g:fontSize<CR>
endif

" Enable PlugInstall bind if vim-plug exists.
if ! pathogenEnabled && os == "linux"
	map <leader>pi :PlugInstall<CR>
endif

" Jump to TODOs in your file.
map tt /TODO<CR>

" Open PowerShell/Cmd/Ubuntu/Debian.
if os == "windows"
	map <leader>termp :terminal powershell<CR>
	map <leader>termc :terminal cmd<CR>
	map <leader>termu :terminal ubuntu<CR>
	map <leader>termd :terminal debian<CR>
endif

" Open default system terminal.
map <leader>term :terminal<CR>

if filereadable(g:mapsFilepath)
	exec "source " . g:mapsFilepath
	call Log("Sourced " . g:mapsFilepath)
endif 


"-------------------------"
" HTML/PHP/JS KEYBINDINGS "
"-------------------------"

autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> t1 :call WrapLine("<h1>", "</h1>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> t2 :call WrapLine("<h2>", "</h2>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> t3 :call WrapLine("<h3>", "</h3>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> t4 :call WrapLine("<h4>", "</h4>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> t5 :call WrapLine("<h5>", "</h5>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> t6 :call WrapLine("<h6>", "</h6>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tB :call WrapLine("<b>", "</b>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tC :call WrapLine("<code>", "</code>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tD :call WrapLine("<\del>", "</del>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tI :call WrapLine("\<i>", "</i>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tS :call WrapLine("<small>", "</small>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> ta :call WrapLine("<a href=\"<++>\">", "</a>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tc :call WrapLine("<center>", "</center>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tcc :call WrapLine("<!-- ", " -->")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> te :call WrapLine("<em>", "</em>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> ti :call WrapLine("<img src=\"", "\">")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tl :call WrapLine("<li>", "</li>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tm :call WrapLine("<mark>", "</mark>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tp :call WrapLine("<p>", "</p>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tt :call WrapLine("<title>", "</title>")<CR>

autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tb :call InsertTag("<br>")<CR>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> th :call InsertTag("<hr>")<CR>

autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> td :call RemoveTagOverCursor()<CR>

autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tg {jwO<ul><Esc>}kwo</ul><Esc>kV?<ul><CR>j>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> to i<ol></ol><Esc>4hi<CR><Esc>O<Esc>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> ts i<section></section><Esc>9hi<CR><Esc>O<Esc>
autocmd BufRead,BufNewFile *rd,*.html,*.php,*.js nnoremap <buffer> tu i<ul></ul><Esc>4hi<CR><Esc>O<Esc>



"----------------------"
" MOVEMENT KEYBINDINGS "
"----------------------"

" ~/.vimrc file.
map <leader>vrc :e ~/.vimrc<CR>

" $HOME directory.
map <leader>gg :e ~/<CR>

" Projects directory.
map <leader>gh :exec ":e " . g:projects . "/"<CR>

" Notes.
map <leader>gn exec ":e " . g:notes<CR>

" Check if abbreviation file exists.
if filereadable(movementsFilepath)
	exec "source " . g:movementsFilepath
	call Log("Sourced " . g:movementsFilepath . ".")
endif


"---------------"
" ABBREVIATIONS "
"---------------"

abbrev @@ TODO

" Check if abbreviation file exists.
if filereadable(abbreviationsFilepath)
	exec "source " . g:abbreviationsFilepath
	call Log("Sourced " . g:abbreviationsFilepath . ".")
endif



autocmd VimEnter * call StartScreen()
