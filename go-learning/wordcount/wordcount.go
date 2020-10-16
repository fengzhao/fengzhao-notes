package main

import (
"fmt"
"io/ioutil"
"os"

"github.com/goinaction/code/chapter3/words"

)

 // main 是应用程序的入口
func main() {

	// 调 os.Args 获取命令行第一个句柄参数（文件名做为参数，也可以是全路径）
	filename := os.Args[1]
	// 调 ioutil.ReadFile 来读取文件内容
	contents, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Println(err)
		return
	}
	// 转为字符串类型
	text := string(contents)
	// 统计字符数量
	count := words.CountWords(text)
	fmt.Printf("There are %d words in your text．\n", count)


}