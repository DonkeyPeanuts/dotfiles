setlocal dictionary=~/.vim/dict/php.dict
setlocal makeprg=php\ -l\ %
autocmd BufWritePost *.php silent make | if len(getqflist()) != 1 | copen | else | cclose | endif
