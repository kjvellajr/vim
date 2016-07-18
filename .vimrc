" pathogen config
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" setup swap files to a temp directory instead of always next to the file
" being edited
set swapfile
set dir=~/tmp

" bind nerdtree to ctrl+n
nmap <C-n> :NERDTreeToggle<CR>

" search by smartcase instead of always using correct capitolization
set smartcase
	
" invisible character colors 
"highlight NonText ctermfg=LightGrey guifg=LightGrey
"highlight SpecialKey ctermfg=LightGrey guifg=LightGrey

" use symbols to represent whitespace
set list
set listchars=tab:?\ ,eol:¬

" add line numbers
set number

" set default window size
set lines=35 columns=150

" set smartcase searching 
:set ignorecase
:set smartcase

" use tabs by default as 4 spaces
set ts=4 sts=4 sw=4 noexpandtab

" set runtimepath for ctrl-p
set runtimepath^=~/.vim/bundle/ctrlp.vim

" only do this part when compiled with support for autocommands
if has("autocmd")
	autocmd BufWritePre *.java,*.js,*.css,*.jsp :call <SID>StripTrailingWhitespaces()
endif

" function to strip trailing whitespaces
function! <SID>StripTrailingWhitespaces()
	" Preparation: save last search, and cursor position.
	let _s=@/
	let l = line(".")
	let c = col(".")
	" Do the business:
	%s/\s\+$//e
	" Clean up: restore previous search history, and cursor position
	let @/=_s
	call cursor(l, c)
endfunction

" syntastic default settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" source the vimrc file after saving it
if has("autocmd") 
	autocmd bufwritepost .vimrc source $MYVIMRC
endif

" map ,v to edit vimrc in new tab
let mapleader = ","
nmap <leader>v :tabedit $MYVIMRC<CR>

" macro to format AccuRev change copy+paste, to use @s
let @s = ':g/^\s*$/d
:%normal @l
:%sort i
:%normal @k
gg' 
let @a = ':g/^\s*$/d
:%normal @j
:%sort i
:%normal @k
gg' 
let @l = '0WWDx?\
lD0Pj' " remove extra content for quick view
let @k = '0Wi€kb40a 040ldt\j' " tab all second WORD by 40 chars
let @j = '0WWWblD0xj' " remove extra content for history view
" macro to delete second WORD from line
let @d = '0WbelDj'

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

" use ctrl-a for number increment instead of windows select all
nunmap <C-a>

" map // in visual mode to find currend selection
vnoremap // y/<C-R>"<CR>

set diffexpr=MyDiff()
function MyDiff()
   let opt = '-a --binary '
   if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
   if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
   let arg1 = v:fname_in
   if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
   let arg2 = v:fname_new
   if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
   let arg3 = v:fname_out
   if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
   if $VIMRUNTIME =~ ' '
     if &sh =~ '\<cmd'
       if empty(&shellxquote)
         let l:shxq_sav = ''
         set shellxquote&
       endif
       let cmd = '"' . $VIMRUNTIME . '\diff"'
     else
       let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
     endif
   else
     let cmd = $VIMRUNTIME . '\diff'
   endif
   silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
   if exists('l:shxq_sav')
     let &shellxquote=l:shxq_sav
   endif
 endfunction

" allow backspacing over everything in insert mode
set backspace=indent,eol,start
