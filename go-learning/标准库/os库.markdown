













## 文件操作



os包里面有个 file.go 文件，这个文件定义了很多文件操作。







### 打开文件/读取文件

```go
// os/file.go源代码
// Open()函数调用 OpenFile()函数来打开文件，用于读取，只读模式
// 返回值是一个File类型的指针，代表了一个打开文件描述符
func Open(name string) (*File, error) {
   return OpenFile(name, O_RDONLY, 0)
}



// 
func OpenFile(name string, flag int, perm FileMode) (*File, error) {
	testlog.Open(name)
	f, err := openFileNolog(name, flag, perm)
	if err != nil {
		return nil, err
	}
	f.appendMode = flag&O_APPEND != 0

	return f, nil
}
```









```go
package main

import (
   "os"
   "io/ioutil"
   "fmt"
)

// 将文件以只读形式读入内存
func OpenFileWithOpen(name string) {

	// 打开文件，第一个返回值是一个指针，指向 File 类型的值，第二个返回值是 error 类型的值，检查 Open 调用是否成功
	file, err := os.Open(name)
	// 检查返回值的错误类型，如果错误类型为 nil 表示打开失败。
	if err != nil {
		log.Println("Open file failed:", err)
		return
		// panic(err)

	}
	// 使用 defer 关键字关闭文件
	defer file.Close()
	// 调用 ioutil 包中方法读取文件
	content, err := ioutil.ReadAll(file)
	// 打印文件内容
	fmt.Println(string(content))
}










// 



```

name() 函数返回了