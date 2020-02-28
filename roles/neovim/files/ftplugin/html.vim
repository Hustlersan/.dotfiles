nnoremap <leader><enter> :silent update<Bar>silent !xdg-open %:p &<CR>
setlocal expandtab tabstop=2 shiftwidth=2

let b:ale_linters = ['htmlhint']
