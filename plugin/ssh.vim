" File: plugin/ssh.vim
" Description: A ctrlp.vim extension - SSH via ctrlp.vim interface.
" Author: Takahiro Yoshihara <tacahiroy\AT/gmail.com>
" License: Modified BSD License

command! -nargs=? CtrlPSSH call ctrlp#init(ctrlp#ssh#id())
