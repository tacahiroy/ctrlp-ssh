" File: autoload/ctrlp/ssh/runner/tmux.vim
" Description: ctrlp-ssh tmux runner
" Author: Takahiro Yoshihara <tacahiroy\AT/gmail.com>
" License: Modified BSD License

let s:tmux = {}

function! s:tmux.type()
  return 'tmux'
endfunction

function! s:tmux.is_installed()
  return !empty(ctrlp#ssh#utils#which('tmux'))
endfunction

function! s:tmux.getopts(host, port, mode)
  let opts = { 'open': '', 'args': [] }

  if a:mode == 'e' || a:mode == 't'
    let opts.open = 'neww'
    call add(opts.args, '-n ' . a:host)
  elseif a:mode == 'v'
    let opts.open = 'splitw -h'
  elseif a:mode == 'h'
    let opts.open = 'splitw -v'
  endif
  
  return opts
endfunction

function! s:tmux.is_running()
  let r = ctrlp#ssh#utils#system('tmux ls -F "#{session_name}:#{session_attached}" | grep :1')
  return r.err == 0
endfunction

function! s:tmux.go(cmd, opts) dict
  if self.is_running()
    let res = ctrlp#ssh#utils#system(printf('tmux %s %s "%s"', a:opts.open, join(a:opts.args, ' '), a:cmd))
    if res.err
      echomsg res.out
    endif
  else
    echomsg 'ERR: tmux is not running'
    return
  endif
endfunction

" Return the instance
"
function! ctrlp#ssh#runner#tmux#new()
  return deepcopy(s:tmux)
endfunction
