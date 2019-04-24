
let s:vim_antlr4_temp_dir = '/tmp/vim_antlr4'
let s:default_antlr4_command = 'antlr4'
let s:default_antlr4_args = '-long-messages -no-listener -no-visitor'

function! s:GetExecutable(...)
    return get(g:, 'antlr4_executable', s:default_antlr4_command)
endfunction

function! s:GetCommand(buffer) abort
    if !isdirectory(s:vim_antlr4_temp_dir)
        call mkdir(s:vim_antlr4_temp_dir)
    endif

    return s:GetExecutable() . ' '
                \ . s:default_antlr4_args
                \ . ' -o ' . s:vim_antlr4_temp_dir 
                \ . ' ' . bufname(a:buffer)
endfunction

function! s:Callback(buffer, lines) abort
    let l:pattern = '\v^(error|warning)\((\d+)\):\s*([^:]*):(\d+)?:(\d+)?: (.*)'

    let l:output = []
    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
                    \   'lnum': l:match[4] + 0,
                    \   'col': l:match[5] + 1,
                    \   'text': l:match[6],
                    \   'filename': l:match[3],
                    \   'nr': l:match[2],
                    \   'type': l:match[1] is# 'error' ? 'E' : 'W',
                    \})

    endfor

    return l:output
endfunction

" Setup ALE checker if present
try
    call ale#linter#Define('antlr4', {
                \   'name': 'vim-antlr4',
                \   'executable': function('s:GetExecutable'),
                \   'command': function('s:GetCommand'),
                \   'callback': function('s:Callback'),
                \   'output_stream': 'both',
                \   'lint_file': 1
                \})
catch /^Vim\%((\a\+)\)\=:E117/
endtry
