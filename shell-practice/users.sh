#! /bin/bash
# Function：根据用户名查询该用户的所有信息
read -p "请输入要查询的用户名：" A
echo "------------------------------"
n=`cat /etc/passwd | awk -F: '$1~/^'$A'$/{print}' | wc -l`
if [ $n -eq 0 ];then
echo "该用户不存在"
echo "------------------------------"
else
  echo "该用户的用户名：$A"
  echo "该用户的UID：`cat /etc/passwd | awk -F: '$1~/^'$A'$/{print}'|awk -F: '{print $3}'`"
  echo "该用户的组为：`id $A | awk {'print $3'}`"
  echo "该用户的GID为：`cat /etc/passwd | awk -F: '$1~/^'$A'$/{print}'|awk -F: '{print $4}'`"
  echo "该用户的家目录为：`cat /etc/passwd | awk -F: '$1~/^'$A'$/{print}'|awk -F: '{print $6}'`"
  Login=`cat /etc/passwd | awk -F: '$1~/^'$A'$/{print}'|awk -F: '{print $7}'`
  if [ $Login == "/bin/bash" ];then
  echo "该用户有登录系统的权限！！"
  echo "------------------------------"
  elif [ $Login == "/sbin/nologin" ];then
  echo "该用户没有登录系统的权限！！"
  echo "------------------------------"
  fi
fi