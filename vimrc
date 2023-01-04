" sets auto indentation to on and set the indent size to be two spaces
set autoindent expandtab tabstop=2 shiftwidth=2 

" because 80 characters in this day and age is archaic
set textwidth=160


filetype on 
filetype plugin on
" syntax highlighting
syntax on
set hidden
" case insensitivity when searching unless you specify uppercase
set ignorecase
set smartcase

" shows indent
set ruler

" if not saved will confirm if you want to on exit
set confirm

" rather than dinging on the shell will flash the screen instead
set visualbell

" sets the colour scheme to elflord ( NCIS joke ) can look for others with
" :colo <ctrl+d>
colorscheme elflord


" forces visual mode
" if has('mouse')
"   set mouse=a
" endif
