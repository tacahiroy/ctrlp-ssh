ctrlp-ssh
============


SYNOPSIS
----------
You can do SSH to a server via ctrlp.vim interface using this plugin.
Note that this plugin is a ctrlp.vim extension and it requires a runner (*tmux* is currently only supported).

![ctrlp-ssh][1]


PREMISE
----------
First, I believe you're a user of a great Vim plugin [ctrlp.vim](https://github.com/kien/ctrlp.vim).
Otherwise, you must install it before start installing this plugin.
Second, this plugin requires tmux to open a new SSH window for now.


INSTALLATION
----------
### [Vundle](https://github.com/gmarik/Vundle.vim)

    :PluginInstall tacahiroy/ctrlp-ssh

In addition, don't forget put a line `Plugin 'tacahiroy/ctrlp-ssh'` into your _.vimrc_.

### [pathogen.vim](https://github.com/tpope/vim-pathogen)

    $ cd ~/.vim/bundle
    $ git clone git://github.com/tacahiroy/ctrlp-ssh.git

If you don't use either plugin management systems, copy _autoload_ and _plugin_ directory to your _.vim_ directory.


CONFIGURATION
----------
You need to make this plugin available as a ctrlp.vim extension. Please add *ssh* to a variable `g:ctrlp_extensions`.

    let g:ctrlp_extensions = ['ssh']

Or if you already use other ctrlp.vim extensions you need to do like this:

    let g:ctrlp_extensions = ['funky', 'ssh']

Then restart Vim and you can use `:CtrlPSSH` command.

It might be useful configuring mapping like:

    nnoremap <Leader>fs :CtrlPSSH<Cr>


LINK
--------------

* [ctrlpvim/ctrlp.vim](https://github.com/ctrlpvim/ctrlp.vim)


LICENSE
-------

Copyright (c) 2013-2014 Takahiro Yoshihara. Distributed under the Modified BSD License.

[1]: http://i.imgur.com/PvIvax0.png
