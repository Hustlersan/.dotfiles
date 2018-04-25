so ~/.projects.private.vim

function! Zf1(...) abort
    let g:ultisnips_php_scalar_types = 0

    nnoremap <c-s> :update<cr>:Silent php-cs-fixer fix %:p --rules=@Symfony<cr>:Silent phpcbf %:p > /dev/null<cr>:e<cr>

    nnoremap <silent> <c-s> :update<cr>:Silent php-cs-fixer fix %:p --rules=@Symfony<cr>:Silent phpcbf --standard=Symfony3Custom %:p > /dev/null<cr>:e<cr>

    nnoremap <silent> <leader>w :w<cr>

    nnoremap <silent> <m-a> :call SwitchBetweenFiles('php', 'tests/', 'library/', 'Test')<cr>
    nnoremap <silent> <leader>tsa <c-w>v:call SwitchBetweenFiles('php', 'tests/', 'library/', 'Test')<cr>

    let g:cm_auto_popup=0 " disable nvim-completion-manager
    call deoplete#enable()

    let g:neomake_php_enabled_makers = ['php', 'phpmd', 'phpcs']
    let g:neomake_open_list = 2
endfunction

function! Symfony(...) abort
    " call deoplete#disable()
    let g:deoplete#sources.php = []
    " let g:cm_matcher.module = 'cm_matchers.abbrev_matcher'
    let g:deoplete#sources.php = ['phpactor', 'ultisnips', 'buffer']
    call deoplete#enable()
    let g:ultisnips_php_scalar_types = 1

    nnoremap <silent> <c-s> :update<cr>:Silent php-cs-fixer fix %:p --rules=@Symfony<cr>:Silent phpcbf --standard=Symfony3Custom %:p > /dev/null<cr>:e<cr>

    nnoremap <m-a> :call SymfonySwitchToAlternateFile()<cr>
    nnoremap <leader>tsa <c-w>v:call SymfonySwitchToAlternateFile()<cr>
    nnoremap <silent> gd :call phpactor#GotoDefinition()<CR>
    nnoremap <silent> gr :call phpactor#FindReferences()<CR>
    nnoremap <leader>tt :call phpactor#Transform()<cr>
    au filetype php set omnifunc=phpactor#Complete

    let g:neomake_php_enabled_makers = ['php', 'phpmd', 'phpcs', 'phpstan']
    let g:neomake_php_enabled_makers = ['php', 'phpmd', 'phpcs']
    let g:neomake_open_list = 2
endfunction
