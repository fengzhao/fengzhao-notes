#!/bin/bash 

# 用途：执行脚本，后接一个Linux命令作为参数，检查其是否在$PATH环境变量的路径中。

in_path(){
    cmd=$1
    ourpath=$2
    result=1
    oldIFS=${IFS}
    IFS=":"

    for directory in $ourpath 
    do 
        if [ -x $directory/$cmd ] ; then 
            result=0
        fi
    done

    IFS=$oldIFS
    return $result
}

checkForCmdInPath(){
    # 获取第一个参数
    var=$1

    if [ "$var" != "" ] ; then 
        # 字符串切片：获取第一个参数的第一个字符，判断是不是以斜杠开头。如果参数名是斜杠开头，则认为是绝对路径，则通过bash操作符-x来检查文件是否存在
        if [ "${var:0:1}" = "/" ] ; then 
            if [ ! -x $var ] ; then 
                return 1
            fi
        elif ! in_path $var "$PATH" ; then 
            return 2
        fi
    fi
       
}



# 主入口
# 检查参数个数，确保只接收一个参数。如果参数个数大于1，打出正确用法说明，错误码为1退出。
if [ $# -ne 1 ] ; then 
    echo " Usage: $0 command " >&2 
    exit 1 
fi 

# 执行函数
checkForCmdInPath "$1"

case $? in 
    0 ) echo "$1 found in PATH"                        ;;
    1 ) echo "$1 not found in PATH or not executable"  ;;
    2 ) echo "$1 not found in PATH"                    ;;
esac 

exit 0 

