" do vim wiki
set nocompatible
filetype plugin on
syntax on

let g:latex_to_unicode_auto = 1

let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

let g:lf_replace_netrw = 1 " Open lf when vim opens a directory

" fix code
"nmap <F2> :ALEFix<CR>
"imap <F2> <C-o>:ALEFix<CR>

"let g:ale_fixers = {'python': [

"vim-syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

"nnoremap m d
"xnoremap m d

"nnoremap mm dd
"nnoremap M D


" languagetool
"let g:languagetool_server_jar='/usr/share/java/languagetool/languagetool-server.jar'
"let g:languagetool_lang = 'en'


" deoplete
"   setting python hosts
" tell deoplete where to search right binarys
"let g:deoplete#sources#jedi#python_path=expand('$VIRTUAL_ENV/bin/python')
""   fallback
"let g:deoplete#sources#jedi#extra_path='/bin/python'
"let g:jedi#auto_initialization = 0
"" Use deoplete.
"let g:deoplete#enable_at_startup = 1
"let g:deoplete#auto_completion_start_length = 0
"let g:deoplete#enable_camel_case = 1
" setting a little delay for windows to appear
"call deoplete#custom#option('auto_complete_delay', 50)




" Vimtex options

    let g:tex_flavor = "latex"
    let g:vimtex_complete_close_braces = 1
    let g:vimtex_view_method = 'zathura'

  " A expressão abaixo tem como função habilitar autocompletação utilizando deoplete
"  if !exists('g:deoplete#omni#input_patterns')
"      let g:deoplete#omni#input_patterns = {}
"  endif
"  let g:deoplete#omni#input_patterns.tex = '\\(?:'
"        \ .  '\w*cite\w*(?:\s*\[[^]]*\]){0,2}\s*{[^}]*'
"        \ . '|\w*ref(?:\s*\{[^}]*|range\s*\{[^,}]*(?:}{)?)'
"        \ . '|hyperref\s*\[[^]]*'
"        \ . '|includegraphics\*?(?:\s*\[[^]]*\]){0,2}\s*\{[^}]*'
"        \ . '|(?:include(?:only)?|input)\s*\{[^}]*'
"        \ . '|\w*(gls|Gls|GLS)(pl)?\w*(\s*\[[^]]*\]){0,2}\s*\{[^}]*'
"        \ . '|includepdf(\s*\[[^]]*\])?\s*\{[^}]*'
"        \ . '|includestandalone(\s*\[[^]]*\])?\s*\{[^}]*'
"
"        j
"
"        \ .')'

" Deoplete options

    " Use deoplete.
    let g:deoplete#enable_at_startup = 1

"colorscheme molokai
hi Normal guibg=NONE ctermbg=NONE
hi LineNr guibg=NONE ctermbg=NONE
hi Search ctermbg=yellow ctermfg=black
hi PmenuSel ctermbg=yellow ctermfg=black
nnoremap <leader>n :GFile<CR>
nnoremap <C-h> <C-w><C-h>
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
let g:airline_powerline_fonts = 1
let g:airline_theme = 'molokai'
let g:airline_mode_map = {
        \ '__' : '------',
        \ 'n'  : 'N',
        \ 'i'  : 'I',
        \ 'R'  : 'R',
        \ 'v'  : 'V',
        \ 'V'  : 'V',
        \ 'c'  : 'C',
        \ '' : 'V',
        \ 's'  : 'S',
        \ 'S'  : 'S',
        \ '' : 'S',
        \ 't'  : 'T',
        \ }
let g:airline_section_b = '[%{gitbranch#name()}]'

"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
colorscheme one
"set background=dark " for the dark version


nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a/ :Tabularize /\/\/<CR>
vmap <Leader>a/ :Tabularize /\/\/<CR>
nmap <Leader>as :Tabularize /::<CR>
vmap <Leader>as :Tabularize /::<CR>
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

nmap s <Plug>(easymotion-overwin-f)

