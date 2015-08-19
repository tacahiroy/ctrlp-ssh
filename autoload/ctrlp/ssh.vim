" File: autoload/ctrlp/ssh.vim
" Description: SSH via ctrlp.vim interface
" Author: Takahiro Yoshihara <tacahiroy\AT/gmail.com>
" License: Modified BSD License

if get(g:, 'loaded_ctrlp_ssh', 0)
  finish
endif
let g:loaded_ctrlp_ssh = 1

let s:saved_cpo = &cpo
set cpo&vim

let s:console = {}
let s:err = { 'status': 0, 'message' : '' }

" The main variable for this extension.
"
" The values are:
" + the name of the input function (including the brackets and any argument)
" + the name of the action function (only the name)
" + the long and short names to use for the statusline
" + the matching type: line, path, tabs, tabe
"                      |     |     |     |
"                      |     |     |     `- match last tab delimited str
"                      |     |     `- match first tab delimited str
"                      |     `- match full line like file/dir path
"                      `- match full line

let s:ext_vars = {
  \ 'init':   'ctrlp#ssh#init()',
  \ 'opts':   'ctrlp#ssh#optparse()',
  \ 'accept': 'ctrlp#ssh#accept',
  \ 'lname':  'ssh',
  \ 'sname':  'ssh',
  \ 'type':   'path',
  \ 'nolim':  0,
  \ 'sort':   1
  \ }

if exists('g:ctrlp_ext_vars') && !empty(g:ctrlp_ext_vars)
  call add(g:ctrlp_ext_vars, s:ext_vars)
else
  let g:ctrlp_ext_vars = [s:ext_vars]
endif

function! s:console.log(msg) dict
  if s:debug | echomsg string(a:msg) | endif
endfunction

function! s:syntax()
  if !ctrlp#nosy()
    call ctrlp#hicheck('CtrlPTabExtra', 'Comment')
    syn match CtrlPTabExtra '\t#.*:\d\+:\d\+$'
  endif
endfunction

function! s:parseline(line)
  let info = split(a:line, ':')
  return [ get(info, 0), get(info, 1, 22) ]
endfunction

function! s:is_autoload(autoload)
  let path = 'autoload/' . substitute(a:autoload, '#', '/', 'g') . '.vim'
  return !empty(globpath(&runtimepath, path))
endfunction

function! s:raise(msg)
  let s:err.status = 1
  let s:err.message = a:msg
  throw a:msg
endfunction

" Get a runner: tmux or screen etc.
" Return: Runner object
" 
function! s:get_runner()
  let autoload = 'ctrlp#ssh#runner#' . get(g:, 'ctrlp_ssh_runner', 'tmux')
  if !s:is_autoload(autoload)
    call s:raise('No such autoload function - ' . autoload)
  endif
  return function(autoload . '#new')()
endfunction

function! s:hosts()
  let lines = readfile(s:server_list_file)

  let hosts = []
  for l in lines
    let c1 = matchstr(l, '^\(\S\+\)')
    for h in split(c1, ',')
      call add(hosts, substitute(h, '[\[\]]', '', 'g'))
    endfor
  endfor

  return hosts
endfunction

" Provide a list of strings to search in
"
" Return: List
function! ctrlp#ssh#init()
  if s:err.status | return | endif
  return s:hosts()
endfunction

" Set options to internal variables
"
function! ctrlp#ssh#optparse()
  let s:server_list_file = get(g:, 'ctrlp_ssh_server_list_file', $HOME . '/.ssh/known_hosts')
  let s:debug = get(g:, 'ctrlp_ssh_debug', 0)
  let s:keep_ctrlp_window = get(g:, 'ctrlp_ssh_keep_ctrlp_window', 0)

  try | let s:runner = s:get_runner()
  catch /^No such autoload/
    echohl Error | echomsg s:err.message | echohl None
  endtry
endfunction

" The action to perform on the selected string.
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
function! ctrlp#ssh#accept(mode, str)
  let [host, port] = s:parseline(a:str)
  let opts = s:runner.getopts(host, port, a:mode)

  call s:runner.go(printf('ssh %s -p %d', host, port), opts)

  if !ctrlp#ssh#is_keep_ctrlp_window()
    call ctrlp#exit()
  endif
endfunction

function! ctrlp#ssh#is_keep_ctrlp_window()
  return s:keep_ctrlp_window
endfunction

function! ctrlp#ssh#previewable()
  return 0
endfunction

" Give the extension an ID
let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)
" Allow it to be called later
function! ctrlp#ssh#id()
  return s:id
endfunction

let &cpo = s:saved_cpo
unlet s:saved_cpo
