## shell 语法结构







## if 条件判断





```shell
if 条件; then
  command1
else
  command2
fi



repo='https://tiup-mirrors.pingcap.com'
# 变量如果不存在，则赋值
if [ -n "$TIUP_MIRRORS" ]; then
    repo=$TIUP_MIRRORS
fi

# 判断操作系统，类似于 case switch 语句 
case $(uname -s) in
    Linux|linux) os=linux ;;
    Darwin|darwin) os=darwin ;;
    *) os= ;;
esac

# 如果os变量变量为空，则输出不支持该操作系统，退出
if [ -z "$os" ]; then
    echo "OS $(uname -s) not supported." >&2
    exit 1
fi

# 操作系统架构
case $(uname -m) in
    amd64|x86_64) arch=amd64 ;;
    arm64|aarch64) arch=arm64 ;;
    *) arch= ;;
esac

# 如果架构为空，则不支持
if [ -z "$arch" ]; then
    echo "Architecture  $(uname -m) not supported." >&2
    exit 1
fi

# $TIUP_HOME环境变量
if [ -z "$TIUP_HOME" ]; then
    TIUP_HOME=$HOME/.tiup
fi
# bin目录
bin_dir=$TIUP_HOME/bin
mkdir -p "$bin_dir"

# 安装二进制文件
# 拼接 URL 
# https://tiup-mirrors.pingcap.com/tiup-linux-amd64.tar.gz?20201109152546  
# 下载上述文件到/tmp目录，然后解压到bin目录
install_binary() {
    curl "$repo/tiup-$os-$arch.tar.gz?$(date "+%Y%m%d%H%M%S")" -o "/tmp/tiup-$os-$arch.tar.gz" || return 1
    tar -zxf "/tmp/tiup-$os-$arch.tar.gz" -C "$bin_dir" || return 1
    rm "/tmp/tiup-$os-$arch.tar.gz"
    return 0
}


# 如果执行失败，返回无法下载或解压
if ! install_binary; then
    echo "Failed to download and/or extract tiup archive."
    exit 1
fi

# 添加755权限
chmod 755 "$bin_dir/tiup"


"$bin_dir/tiup" mirror set $repo

```





```shell

if 常用参数：
文件/目录判断：
[ -a FILE ] 如果 FILE 存在则为真。 
[ -b FILE ] 如果 FILE 存在且是一个块文件则返回为真。
[ -c FILE ] 如果 FILE 存在且是一个字符文件则返回为真。
[ -d FILE ] 如果 FILE 存在且是一个目录则返回为真。 
[ -e FILE ] 如果 指定的文件或目录存在时返回为真。
[ -f FILE ] 如果 FILE 存在且是一个普通文件则返回为真。
[ -g FILE ] 如果 FILE 存在且设置了SGID则返回为真。
[ -h FILE ] 如果 FILE 存在且是一个符号符号链接文件则返回为真。（该选项在一些老系统上无效）
[ -k FILE ] 如果 FILE 存在且已经设置了冒险位则返回为真。
[ -p FILE ] 如果 FILE 存并且是命令管道时返回为真。
[ -r FILE ] 如果 FILE 存在且是可读的则返回为真。
[ -s FILE ] 如果 FILE 存在且大小非0时为真则返回为真。
[ -u FILE ] 如果 FILE 存在且设置了SUID位时返回为真。
[ -w FILE ] 如果 FILE 存在且是可写的则返回为真。（一个目录为了它的内容被访问必然是可执行的）
[ -x FILE ] 如果 FILE 存在且是可执行的则返回为真。
[ -O FILE ] 如果 FILE 存在且属有效用户ID则返回为真。
[ -G FILE ] 如果 FILE 存在且默认组为当前组则返回为真。（只检查系统默认组）
[ -L FILE ] 如果 FILE 存在且是一个符号连接则返回为真。 
[ -N FILE ] 如果 FILE 存在 and has been mod如果ied since it was last read则返回为真。 
[ -S FILE ] 如果 FILE 存在且是一个套接字则返回为真。
[ FILE1 -nt FILE2 ] 如果 FILE1 比 FILE2 新, 或者 FILE1 存在但是 FILE2 不存在则返回为真。 
[ FILE1 -ot FILE2 ] 如果 FILE1 比 FILE2 老, 或者 FILE2 存在但是 FILE1 不存在则返回为真。
[ FILE1 -ef FILE2 ] 如果 FILE1 和 FILE2 指向相同的设备和节点号则返回为真。


字符串判断
[ -z STRING ]    如果STRING的长度为零则返回为真，即空是真
[ -n STRING ]    如果STRING的长度非零则返回为真，即非空是真
[ STRING1 ]　   如果字符串不为空则返回为真,与-n类似
[ STRING1 == STRING2 ]   如果两个字符串相同则返回为真
[ STRING1 != STRING2 ]    如果字符串不相同则返回为真
[ STRING1 < STRING2 ]     如果 “STRING1”字典排序在“STRING2”前面则返回为真。 
[ STRING1 > STRING2 ]     如果 “STRING1”字典排序在“STRING2”后面则返回为真。 


数值判断
[ INT1 -eq INT2 ]          INT1和INT2两数相等返回为真 ,=
[ INT1 -ne INT2 ]          INT1和INT2两数不等返回为真 ,<>
[ INT1 -gt INT2 ]           INT1大于INT2返回为真 ,>
[ INT1 -ge INT2 ]          INT1大于等于INT2返回为真,>=
[ INT1 -lt INT2 ]            INT1小于INT2返回为真 ,<
[ INT1 -le INT2 ]           INT1小于等于INT2返回为真,<=


逻辑判断
[ ! EXPR ]       逻辑非，如果 EXPR 是false则返回为真。
[ EXPR1 -a EXPR2 ]      逻辑与，如果 EXPR1 and EXPR2 全真则返回为真。
[ EXPR1 -o EXPR2 ]      逻辑或，如果 EXPR1 或者 EXPR2 为真则返回为真。
[  ] || [  ]           用OR来合并两个条件
[  ] && [  ]        用AND来合并两个条件


其他判断
[ -t FD ]  如果文件描述符 FD （默认值为1）打开且指向一个终端则返回为真
[ -o optionname ]  如果shell选项optionname开启则返回为真


IF高级特性：
双圆括号((  ))：表示数学表达式
    在判断命令中只允许在比较中进行简单的算术操作，而双圆括号提供更多的数学符号，而且在双圆括号里面的'>','<'号不需要转意。

双方括号[[  ]]：表示高级字符串处理函数
    双方括号中判断命令使用标准的字符串比较，还可以使用匹配模式，从而定义与字符串相匹配的正则表达式。

双括号的作用：
在shell中，[ $a != 1 || $b = 2 ]是不允许出，要用[ $a != 1 ] || [ $b = 2 ]，而双括号就可以解决这个问题的，[[ $a != 1 || $b = 2 ]]。又比如这个[ "$a" -lt "$b" ]，也可以改成双括号的形式(("$a" < "$b"))


实例
1：判断目录$doiido是否存在，若不存在，则新建一个
if [ ! -d "$doiido"]; then
　　mkdir "$doiido"
fi

2：判断普通文件$doiido是否存，若不存在，则新建一个
if [ ! -f "$doiido" ]; then
　　touch "$doiido"
fi

3：判断$doiido是否存在并且是否具有可执行权限
if [ ! -x "$doiido"]; then
　　mkdir "$doiido"
    chmod +x "$doiido"
fi

4：是判断变量$doiido是否有值
if [ ! -n "$doiido" ]; then
　　echo "$doiido is empty"
　　exit 0
fi

5：两个变量判断是否相等
if [ "$var1" = "$var2" ]; then
　　echo '$var1 eq $var2'
else
　　echo '$var1 not eq $var2'
fi

6：测试退出状态：
if [ $? -eq 0 ];then
    echo 'That is ok'
fi

7：数值的比较：
if [ "$num" -gt "150" ]
    echo "$num is biger than 150"
fi

8：a>b且a<c
(( a > b )) && (( a < c ))
[[ $a > $b ]] && [[ $a < $c ]]
[ $a -gt $b -a $a -lt $c ]

9：a>b或a<c
(( a > b )) || (( a < c ))
[[ $a > $b ]] || [[ $a < $c ]]
[ $a -gt $b -o $a -lt $c ]

10：检测执行脚本的用户
if [ "$(whoami)" != 'root' ]; then
    echo "You have no permission to run $0 as non-root user."
    exit 1;
fi
上面的语句也可以使用以下的精简语句
[ "$(whoami)" != 'root' ] && ( echo "You have no permission to run $0 as non-root user."; exit 1 )

11：正则表达式
doiido="hero"
if [[ "$doiido" == h* ]];then 
    echo "hello，hero"
fi


============其他例子============
1、查看当前操作系统类型
#!/bin/sh
SYSTEM=`uname -s`
if [ $SYSTEM = "Linux" ] ; then
    echo "Linux"
elif [ $SYSTEM = "FreeBSD" ] ; then
    echo "FreeBSD"
elif [ $SYSTEM = "Solaris" ] ; then
    echo "Solaris"
else
    echo "What?"
fi

2、if利用read传参判断
#!/bin/bash
read -p "please input a score:" score
echo -e "your score [$score] is judging by sys now"

if [ "$score" -ge "0" ]&&[ "$score" -lt "60" ];then
    echo "sorry,you are lost!"
elif [ "$score" -ge "60" ]&&[ "$score" -lt "85" ];then
    echo "just soso!"
elif [ "$score" -le "100" ]&&[ "$score" -ge "85" ];then
    echo "good job!"
else
    echo "input score is wrong , the range is [0-100]!"
fi

3、判断文件是否存在
#!/bin/sh
today=`date -d yesterday +%y%m%d`
file="apache_$today.tar.gz"
cd /home/chenshuo/shell
if [ -f "$file" ];then
    echo "OK"
else
    echo "error $file" >error.log
    mail -s "fail backup from test" loveyasxn924@126.com <error.log
fi

4、这个脚本在每个星期天由cron来执行。如果星期的数是偶数，他就提醒你把垃圾箱清理：
#!/bin/bash
WEEKOFFSET=$[ $(date +"%V") % 2 ]

if [ $WEEKOFFSET -eq "0" ]; then
    echo "Sunday evening, put out the garbage cans." | mail -s "Garbage cans out" your@your_domain.org
fi

5、挂载硬盘脚本(windows下的ntfs格式硬盘)
#! /bin/sh
dir_d=/media/disk_d
dir_e=/media/disk_e
dir_f=/media/disk_f

a=`ls $dir_d | wc -l`
b=`ls $dir_e | wc -l`
c=`ls $dir_f | wc -l`

echo "checking disk_d..."
if [ $a -eq 0 ]; then
  echo "disk_d is not exsit,now creating..."
  sudo mount -t ntfs /dev/disk/by-label/software /media/disk_d
else
  echo "disk_d exits"
fi

echo "checking disk_e..."
if [ $b -eq 0 ]; then
  echo "disk_e is not exsit,now creating..."
  sudo mount -t ntfs /dev/disk/by-label/elitor /media/disk_e
else
  echo "disk_e exits"
fi

echo "checking disk_f..."
if [ $c -eq 0 ]; then
  echo "disk_f is not exsit,now creating..."
  sudo mount -t ntfs /dev/disk/by-label/work /media/disk_f
else
  echo "disk_f exits"
fi
```

