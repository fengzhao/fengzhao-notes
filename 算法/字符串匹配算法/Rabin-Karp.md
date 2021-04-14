# 背景





一个很简单的问题，给定一个字符串 txt 和一个模式串 pat ，写一个函数 search 来输出字符串 txt 中所有和 pat 相等的子串。

比如：

```go
txt="this is a test text"
pat="text"
```



这个问题的思路很简单，我们只要暴力穷举所有 txt 中所有长度等于 len(pat) 的子串，并判断其是否和 pat 相等即可。



在判断子串是否和 pat 相等时，我们需要逐位去比较。