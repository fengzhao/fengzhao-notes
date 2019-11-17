set showcmd
syntax on

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" 底部状态栏，显示VIM模式，文件编码类型，光标所在行数，列数
Plug 'vim-airline/vim-airline'
Plug 'junegunn/vim-easy-align'
" vim颜色主题
Plug 'flazz/vim-colorschemes'
Plug 'scrooloose/nerdtree'
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" 设置高亮光标所在的行列
set cursorcolumn
set cursorline


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""插件行为配置""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""NERDTree"""""""""""""""""
" vim启动时自动启动NERDTree 
" autocmd vimenter * NERDTree
" 按F3隐藏或显示NERDTree
map <F3> :NERDTreeMirror<CR>
map <F3> :NERDTreeToggle<CR>
" 启用鼠标支持
set mouse=a
" 显示隐藏文件 
let NERDTreeShowHidden=1

""""""""""""""""""""""""""""""""""""""""




""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



" 配色主题
colorscheme molokai

" Vim 可以检测要编辑的文件类型。这是通过检查文件名完成的，有的时候也检查文本里是否包含特定的文本。
" http://vimcdoc.sourceforge.net/doc/filetype.html
filetype on











""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 使用vim新建尚不存在的文件时，自动添加文件头部注释。http://vimcdoc.sourceforge.net/doc/autocmd.html#autocmd.txt
autocmd  BufNewFile *.[ch],*.hpp,*.cpp,Makefile,*.mk,*.sh exec ":call SetTitle()"

func SetComment_sh()
" 给第三行位置的文本内容设置为"########"
        call setline(3,"###############################################################################")
        call setline(4,"#")
        call setline(5,"#  Copyleft (C) ".strftime("%Y")." FengZhao. All rights reserved.")
        call setline(6,"#   FileName：".expand("%:t"))
        call setline(7,"#   Author：FengZhao")
        call setline(8,"#   Date：".strftime("%Y-%m-%d"))
        call setline(9,"#   Description：")
        call setline(10,"#")
        call setline(11,"###############################################################################")
endfunc

func SetTitle()
        if &filetype == 'py'
                call setline(1,"#!/usr/bin/python")
                call setline(2,"")
                call SetComment_sh()

        elseif &filetype == 'sh'
                call setline(1,"#!/bin/bash")
                call setline(2,"")
                call SetComment_sh()
        endif
endfunc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
