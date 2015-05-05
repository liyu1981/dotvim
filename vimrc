" init pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Generel
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" disable vi compatible mode
set nocompatible

" setup max history of cmd: and cmd:search
set history=200

" verbose mode for cmd input
set showcmd

" show current mode
set showmode

" no toolbar
set guioptions-=T

" mouse
"set mouse=a

" use backspace for more things
set backspace=start,indent,eol

" associate clipboard with current system (X)
set clipboard+=unnamed

" show current cursor position
set ruler

" show line number
"set number

" hilight current line
"set cursorline

" default vim encoding
set encoding=utf-8

" default vim file encoding
set fileencodings=utf-8,ucs-bom,cp936,gb18030,big5,euc-jp,euc-kr,latin1

" make tabs etc visiable
"set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list

" status line setup
set laststatus=2
set statusline=
"set statusline+=%2*%-3.3n%0*\
set statusline+=%f\
set statusline+=%h%1*%m%r%w%0*
set statusline+=[
if v:version >= 600
    set statusline+=%{strlen(&ft)?&ft:'none'},
    set statusline+=%{&encoding},
endif
set statusline+=%{&fileformat}]
set statusline+=%=
set statusline+=0x%-8B\
set statusline+=%-14.(%l,%c%V%)\ %<%P

" no backup files
"set nobackup
"set nowb

" set current dir to current buffer
set bsdir=buffer

"colorscheme desert
"colorscheme jellybeans
"colorscheme desertEx
colorscheme flattown

" util for alias command
" http://stackoverflow.com/questions/3878692/aliasing-a-command-in-vim
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Programming
"""""""""""""""""""""""""""""""""""""""""""""""""""

" file type auto detect
filetype plugin indent on

" syntax highlighting
syntax on

" smart indent
set smartindent

" default tab = x spaces
set tabstop=2

" softtab
set softtabstop=2

" no tab, use spaces instead
set expandtab

" auto indention
set ai

" indention width
set cindent shiftwidth=2

" search options
set incsearch
set hlsearch
set wrapscan
set ignorecase

" show match points
set showmatch
set matchpairs=(:),{:},[:],<:>

" auto move to next line with backspace, space, up and down
set whichwrap =b,s,<,>,[,]

" paste mode
set paste

" folding setting
set foldmethod=marker
set foldlevel=3
"set foldcolumn=1

" when save (f2), clean buffer and trim every lines
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif
map <F2> :w<CR>:call CleanupBuffer(1)<CR>:noh<CR>

function! CleanupBuffer(keep)
  if (&bin > 0)
    return
  endif
  silent! %s/\s\+$//ge
  let lnum = line(".")
  let lastline = line("$")
  let n = lastline
  while (1)
    let line = getline(n)
    if (!empty(line))
      break
    endif
    let n = n - 1
  endwhile
  let start = n+1+a:keep
  if (start < lastline)
    execute n+1+a:keep . "," . lastline . "d"
  endif
  exec "normal " . lnum . "G"
endfunction

" netrw
"let g:netrw_winsize=30
"let g:netrw_liststyle=1
"let g:netrw_timefmt='%Y-%m-%d %H:%M:%S'
"nmap <silent> <C-F7> :Sexplore!<cr>

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

" match chars after 80th column and show them in red!
" make it autocmd so it will survive any situation including open in tab
autocmd BufEnter * match Error /\%81v.\+/

" make sure that everything is in utf-8
set ff=unix
set encoding=utf-8
set fileencoding=utf-8

" cscope
set nocscopeverbose

" make vim load bash alias
if &diff
else
  set shellcmdflag=-ic
endif

" indent guide
let g:indent_guides_guide_size = 1
hi IndentGuidesOdd  ctermbg=grey
hi IndentGuidesEven ctermbg=darkgrey

" Turn on spell checking for asciidoc
autocmd BufRead,BufNewFile *.asciidoc setlocal spell spelllang=en_us

" Python setting
autocmd BufEnter *.py set expandtab

" ejs autodetect
au BufNewFile,BufRead *.ejs setf ejs

" airline

" vim-flow
let g:flow#enable = 0

" Shell cmd
" ref: http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

" gui setting
if has('gui_running')
  if has('gui_gtk')
    " setting for linux gvim
    set guifont=Consolas\ 13
    colorscheme flattown
    " get back the shift insert
    map  <silent>  <S-Insert>  "+p
    imap <silent>  <S-Insert>  <Esc>"+pa
  endif
  if has('gui_macvim')
    set guifont=set guifont=Andale\ Mono:h14
    set antialias
    colorscheme flattown
  endif
  set nu
  " set linespace in gui mode
  set lsp=4
  let g:filepirate_accept_to = "tabe"
else
  let g:filepirate_accept_to = "vsp"
endif
