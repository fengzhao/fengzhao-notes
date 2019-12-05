"""""""""""""""""


""""""""""""""""""""""""""""""""""""""""""""vim 原生配置"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 默认字符编码
set fenc=utf-8
" 语法高亮
syntax on
" 设置不折行
set nowrap
set showcmd
syntax on
" 设置高亮光标所在的行列
set cursorcolumn
set cursorline
" 配色主题
" Vim 可以检测要编辑的文件类型。这是通过检查文件名完成的，有的时候也检查文本里是否包含特定的文本。
" http://vimcdoc.sourceforge.net/doc/filetype.html
filetype on
" 设置以unix的格式保存文件
set fileformat=unix
" 设置配色主题
colorscheme molokai

" 距离顶部和底部5行
set scrolloff=5
" 命令行行高
set cmdheight=2
" 显示状态栏
set laststatus=2
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""




""""""""""""""""""""""""""""""""""""""""使用 vim-plug 来管理插件"""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" 底部状态栏插件：显示VIM模式，文件编码类型，光标所在行数，列数
Plug 'vim-airline/vim-airline'
Plug 'junegunn/vim-easy-align'
" 颜色主题插件
Plug 'flazz/vim-colorschemes'
" 导航插件
Plug 'scrooloose/nerdtree'
call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""





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
