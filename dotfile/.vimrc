"==============================================================================
" vim 内置配置 
"==============================================================================

" 设置 vimrc 修改保存后立刻生效，不用在重新打开
" 建议配置完成后将这个关闭
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" 关闭兼容模式,默认配置
set nocompatible

" 启动鼠标支持，在xterm和gui中才能支持
set mouse=a

" 默认字符编码
set fenc=utf-8 


" 防止中文乱码
set fileencodings=utf-8,gb2312,gb18030,gbk,ucs-bom,cp936,latin1
set enc=utf8
set fencs=utf8,gbk,gb2312,gb18030

" 显示行号
set number

" 语法高亮
syntax on
" 设置不折行
set nowrap
set showcmd
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

" 自动对齐
Plug 'junegunn/vim-easy-align'

" 配色方案
" colorscheme neodark
Plug 'KeitaNakamura/neodark.vim'
" colorscheme monokai
Plug 'crusoexia/vim-monokai'
" colorscheme github 
Plug 'acarapetis/vim-colors-github'
" colorscheme one 
Plug 'rakr/vim-one'

" go 主要插件,require vim8+ version
" Plug 'fatih/vim-go', { 'tag': '*' }

" go 中的代码追踪，输入 gd 就可以自动跳转
" Plug 'dgryski/vim-godef'

" 目录导航侧边栏插件
Plug 'scrooloose/nerdtree'

" 可以使 nerdtree 的 tab 更加友好些
Plug 'jistr/vim-nerdtree-tabs'

" 可以在导航目录中看到 git 版本信息
Plug 'Xuyuanp/nerdtree-git-plugin'

" 下面两个插件要配合使用，可以自动生成代码块
" Plug 'SirVer/ultisnips'
" Plug 'honza/vim-snippets'

" 可以在 vim 中使用 tab 补全
" Plug 'vim-scripts/SuperTab'

" 可以在 vim 中自动完成
" Plug 'Shougo/neocomplete.vim'

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
