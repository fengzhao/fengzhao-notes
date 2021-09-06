#!/bin/bash

# 定义变量方便引用

error1='语法格式不对，请参考以下格式输入: createuser -u username -m passwd '

error2='用户名仅包含字母、数字和下划线'

right1='密码已更新'

right2='创建成功并设置密码为'

# 首先判断命令语法是否合法，不合法就输出错误提示error1，并退出，返回值1

# 判断用户名是否合法，不合法就输出错误提示error2，并退出，返回值1

# 判断用户是否存在

# 创建用户并设置密码

if [ "$1" == "-u" ] && [ "$2" ] && [ "$3" == "-m" ] && [ "$4" ] && [ -z "$5" ];then

if [[ "$2" =~ ^[[:alpha:]]([[:alnum:]]|_)* ]];then

 if [[ "$4" =~ .{6,} ]];then

            if [ "$(id $2 &> /dev/null && echo true || echo false)" == true ];then

                 if [[ "$(pwconv ;getent shadow |grep ^$2 |cut -d: -f2)" =~ ^('!$'|'!!$'|'$').* ]];then

                    echo "该用户已存在密码!"

                    exit

                 else

           echo "$4" | passwd --stdin "$2" &> /dev/null && echo "用户 $2 $right1 ";exit

                fi  

            else

                useradd $2 && echo "$4" |passwd --stdin $2 &> /dev/null && echo "用户 $2 $right2 $4"

                exit

           fi

  else

           echo "请重新执行命令，输入不低于六位的密码！！" 1>&2

           exit 1

  fi

   else

        echo "$error2" 1>&2 ;exit 1

  fi

else

    echo "$error1" 1>&2 ;exit 1

fi

unset error1 error2 right1 right2