## 使用 go 構建 lolcat 命令行應用程序

### Linux自帶的 `cat` 命令

在 Linux 中，我們經常使用 cat 來查看一個文件的内容，根據 man 手冊的定義，我們發現這個命令的作用是連接文件并輸出到標準輸出。

> ​       cat - concatenate files and print on the standard output   ——Linux man pages

```shell
# 它的用法如下：
cat [OPTION]... [FILE]...
# 參數： 
-n 或 --number：由 1 开始对所有输出的行数编号。

-b 或 --number-nonblank：和 -n 相似，只不过对于空白行不编号。

-s 或 --squeeze-blank：当遇到有连续两行以上的空白行，就代换为一行的空白行。

-v 或 --show-nonprinting：使用 ^ 和 M- 符号，除了 LFD 和 TAB 之外。

-E 或 --show-ends : 在每行结束处显示 $。

-T 或 --show-tabs: 将 TAB 字符显示为 ^I。

-e : 等价于 -vE。

-A, --show-all：等价于 -vET。

-e：等价于"-vE"选项；

-t：等价于"-vT"选项；
 
```



### lolcat命令

我們平時使用的 `cat` 命令都是黑色的輸出，比較單調，github 上有人用 `ruby` 寫了一個程序 [lolcat](<https://github.com/busyloop/lolcat>) ，可以認爲這個命令是彩色版的 `cat`，它可以在終端中輸出彩色的標準輸出。

```shell
# 安裝 ruby 環境
$ apt install ruby
#　安裝 lolcat 程序	
$ gem install lolcat

# 使用來讓標準輸出帶出更好看的彩色
$ lolcat --help 
$ ls -al | lolcat
```



### 使用 golang 構建自己的 lolcat 程序

首先，使用 <https://github.com/enodata/faker>  這個項目來生成一些 fake 的標準輸出





