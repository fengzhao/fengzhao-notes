
#!/bin/bash
 
# 该脚本用于打包某目录(可以是绝对路径)下的指定扩展名的文件


# 如果 脚本传参个数小于1 或 脚本第一个参数是 . 或脚本第一个参数是 ./  
# 则 DIR 为当前目录 
if [ $# -lt 1 ] || [ "$1" = "." ] || [ "$1" = "./" ]; then
	DIR=`pwd`

# 否则，DIR为第一个参数，如果DIR不存在，则退出    
else
	DIR=$1
	if [ ! -e $DIR ]; then
		echo "Directory-[$DIR] not exist, exit now!"
		exit
	fi
fi
 
packageName=`basename_$DIR`.tar.gz						# 压缩包文件名
 
if [ -e "$packageName" ]; then
	mv -f $packageName "$packageName".bak				# 备份原有的压缩包
fi
 
packSrcs()												# 查找相关文件并打包
{
	DIR=$1
	packageName=$2
	pattern=$3
 
	IFS='|' read -a array <<< "$patten"					# 将pattern以"|"作分割, 将结果存入array
 
	n=${#array[@]}
	index=1
 
	# 接下来组合查找字符并打包的字符串
	findstr="find $DIR -name '*${array[0]}'"
	while test $index -lt $n
	do
		findstr="$findstr -o -name '*${array[index]}'"
		let "index = index + 1"
	done
 
	dosh="$findstr | xargs tar -P -zcvf $packageName"
 
	#echo $dosh
	eval $dosh											# 将字符串当命令执行
}
 
patten=".lua|.luac|.sh|.bat|.cpp|.c|.h|.hpp|.sln"		# 要打包的文件的扩展名
#patten=".lua|.sh|.bat"
 
 
packSrcs $DIR $packageName $pattern						# 调用打包函数

