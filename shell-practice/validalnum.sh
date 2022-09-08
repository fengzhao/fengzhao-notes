#!/bin/bash 

# 用户总是无视操作指南，输入一些不正确或格式不对的数据，如何在bash中校验用户输入。
# 一种典型的情况：要求用户的输入仅限为 "数字或字母"

function validAlphaNum(){

    # 将原始输入的字符串移除无效字符后再赋给新变量，再将其与原始字符串比较
    validchars="$(echo $1 | sed -e 's/[^[:alnum:]]//g')"

    # 比较
    if [ ${validchars} = $1 ] ; then
        return 0
    else
        return 1
    fi

}








# =====================================
# 主脚本
/bin/echo -n "Enter input: "
read input

# 输入验证，调用这个验证函数
if ! validAlphaNum ${input};  then
    echo "input is invalid"
    exit 1
else 
    echo "input is valid"
fi

exit 0 
