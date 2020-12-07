## Go 语言的文档



### 阅读文档

Go 语言有两种方法为开发者阅读文档，使用命令行来阅读文档



比如，在终端环境下，我们要查看一个包的文档，可以直接使用 go doc tar 这样的形式来查看 tar 这个包的文档。





```shell
go doc tar 

package tar // import "archive/tar"

Tape archives (tar) are a file format for storing a sequence of files that
can be read and written in a streaming manner. This package aims to cover
most variations of the format, including those produced by GNU and BSD tar
tools.

const TypeReg = '0' ...
var ErrHeader = errors.New("archive/tar: invalid tar header") ...
type Format int
    const FormatUnknown Format ...
type Header struct{ ... }
    func FileInfoHeader(fi os.FileInfo, link string) (*Header, error)
type Reader struct{ ... }
    func NewReader(r io.Reader) *Reader
type Writer struct{ ... }
    func NewWriter(w io.Writer) *Writer
```



go 文档也可以生成浏览器版本，可以使用 godoc -http=:6060  这个命令，可以在本地启动用一个 WEB 服务器，可以导航到 localhost:6060。

包含所有 Go 标准库和你的GOPATH 下的 Go 源代码的文档。官网的文档就是通过这个略微修改后生成的。要进入查看特定的包，点击页面顶端超链接就可以。



### 生成文档

如果开发人员遵循 go doc 规则来写代码，则自己的代码也可以生成 go doc 文档，可以自动生成代码说明文档。

- **文档和代码位于一起**

  写代码的同时也可以写文档，这可能是写文档最简单的方式之一；

- **使用 [`godoc`](https://godoc.org/golang.org/x/tools/cmd/godoc) 生成文档**

   `godoc` 是一个命令行工具，可以将源码中的文档提取出来生成一定形式的 HTML 页面（或者只是纯文本）。用户可以通过 `godoc` 提供的 Web Server 来浏览文档；



