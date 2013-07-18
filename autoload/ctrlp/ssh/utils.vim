" File: autoload/ctrlp/ssh/utils.vim
" Description: common utillity functions
" Author: Takahiro Yoshihara <tacahiroy\AT/gmail.com>
" License: Modified BSD License

function! ctrlp#ssh#utils#system(cmd)
  let res = system(a:cmd)
  return { 'out': res, 'err': v:shell_error }
endfunction

function! ctrlp#ssh#utils#which(cmd)
  let res = ctrlp#ssh#utils#system('which ' . a:cmd)
  if res.err
    return ''
  else
    return substitute(res.out, '\n$', '', '')
  endif
endfunction

