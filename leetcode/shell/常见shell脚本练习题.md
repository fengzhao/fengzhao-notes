#### leetcode 192

> https://leetcode.com/problems/word-frequency/Pack





题目描述：

统计一个文本文件 file.txt 中每个单词出现的次数。

为了简单，你可以简单理解为：

- file.txt 中只包含小写字母和空格字符	 
- 每个单词都由小写字符构成
- 单词之间由一个或多个空白字符分割

示例：对于 file.txt 文件，有如下内容：

```shell
the day is sunny the the
the sunny is is
```

你的脚本需要输出如下内容，按照频率降序排列：

```shell
the 4
is 3
sunny 2
day 1
```



方案一、

```shell
awk -F' '   '{for(i=1;i<=NF;i=i+1){print $i}}' words.txt | sort | uniq -c | sort -nr | awk -F' ' '{printf("%s %s\n",$2,$1)}'
```

思路：

​	1、用 awk 以空白字符为分隔符，迭代当前的每一列，把单词切出来，逐行输出（每一行只有一个单词）。

​	2、对上述输出排序（sort），去重统计次数（uniq -c 去重复，并计算每行出现的次数）

​	3、对去重的结果再排序（sort -nr）-n 按照数字大小排序，-r 降序排列。

​	4、把结果传给 awk ，按照要求的格式输出，单词在前，次数在后。



方案二、

```shell
grep -e '[a-z]*' -o words.txt  | sort | uniq -c | sort -nrk 1 | awk '{print $2" "$1;}'
```

思路：

​	1、grep -e  PATTERN  指定 pattern  -o 仅显示匹配到的部分。  '[a-z]*'  连续的小写字母序列即为单词。

​	（也是取出单词，逐行输出。每一行只有一个单词。）

​	2、对上述输出排序（sort），去重统计次数（uniq -c 去重复，并计算每行出现的次数）。

​	3、对去重的结果再排序（sort -nr）-n 按照数字大小排序，-r 降序排列，-k 1 以第一列排序

​	4、把结果传给 awk ，按照要求的格式输出。























