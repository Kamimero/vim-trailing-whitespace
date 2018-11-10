
if exists('loaded_trailing_whitespace_plugin')
	finish
endif
let loaded_trailing_whitespace_plugin = 1

let s:ctermbg = get(g:, "trailing_whitespace_ctermbg", "darkred")
let s:guibg = get(g:, "trailing_whitespace_guibg", "darkred")

if !exists('g:extra_whitespace_ignored_filetypes')
    let g:extra_whitespace_ignored_filetypes = []
endif

function! ShouldMatchWhitespace()
    for s:ft in g:extra_whitespace_ignored_filetypes
        if s:ft ==# &filetype
			return 0
		endif
    endfor
    return 1
endfunction

execute "highlight default ExtraWhitespace " . "ctermbg=" . s:ctermbg . " guibg=" . s:ctermbg
execute "autocmd ColorScheme * highlight default ExtraWhitespace " . "ctermbg=" . s:ctermbg . " guibg=" . s:ctermbg

autocmd BufNew,BufEnter *
	\	if ShouldMatchWhitespace() |
	\		match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/ |
	\	else |
	\		match ExtraWhitespace /^^/ |
	\	endif

" The above flashes annoyingly while typing, be calmer in insert mode
autocmd InsertLeave *
	\	if ShouldMatchWhitespace() |
	\		match ExtraWhitespace /\\\@<![\u3000[:space:]]\+$/ |
	\	endif

autocmd InsertEnter *
	\	if ShouldMatchWhitespace() |
	\		match ExtraWhitespace /\\\@<![\u3000[:space:]]\+\%#\@<!$/ |
	\	endif

function! s:FixWhitespace(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\\\@<!\s\+$//'
    call setpos('.', l:save_cursor)
endfunction

" Run :FixWhitespace to remove end of line white space
command! -range=% FixWhitespace call <SID>FixWhitespace(<line1>,<line2>)

