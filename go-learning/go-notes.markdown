## go语言创世纪

go语言最初由贝尔实验室的团队，加入谷歌公司后，开发的一款开源的编程语言。使用BSD开源协议发布。

任何人都可以看Go语言的所有源代码，并可以为Go语言发展而贡献自己的力量。

go是静态的编译型语言。

Google作为Go语言的主推者，并没有简简单单地把语言推给开源社区了事，它不仅组建了一个独立的小组全职开发Go语言，还在自家的业务中逐步增加对Go语言的支持。

比如对于Google有战略意义的云计算平台GAE（Google AppEngine）很早就开始支持Go语言了。

按目前的发展态势，在Google内部，Go语言有逐步取代Java和Python主流地位的趋势。

在Google的更多产品中，我们将看到Go语言的身影，比如Google最核心的搜索和广告业务。

第一个正式版本的Go语言于2012年3月28日正式发布，让Go语言引来了第一个引人瞩目的里程碑。



##  包和文件

golang 以包来组织程序，包类似于其他语言中的库，一个包由一个或多个 .go 为文件名后缀的源代码文件组成。

一系列 .go 的源文件放在一个文件夹中，就叫做一个包。一个包内的不同源文件中的常量、变量、类型、函数名、结构字段等都是对包内其他源文件可见的。

放在一个文件夹中，文件夹描述了包名的作用。**一般用文件夹名做为包名。**

每一个 .go 文件都**属于且仅属于**一个包。（很显然，一个文件只能放在一个文件夹内）

即  \go\src\net 是一个文件夹，就是一个包，这个包名叫 net  ，net 目录里面的所有 go 文件都要声明 package net 

每一个源文件中第一行使用 package 来声明这个文件所属的包。后面跟上 import 关键字来导入其他包。

例如 ：gopl.io/ch1/helloworld 这个包对应的目录路径是 $GOPATH/src/gopl.io/ch1/helloworld

每个包提供了独立的 **命名空间**。包内的标识符需要通过大写字母开头来表示可以被外部包引用。

引用外部包中的变量或函数时，一般通过 **package.Identifier** 这样的格式引用

包可以看做一个类库或者命名空间，当在一个 .go 文件里导入一个包后，就可以使用该包里面的常量、变量、类型、函数名、结构字段等等。



- 一个文件夹下只能有一个package

- 

  

   

### 包命名规范

go语言的包的命名，**遵循简洁、全小写、和go文件所在目录同名的原则**，这样就便于我们引用，书写以及快速定位查找。

比如go自带的http这个包，它这个http目录下的所有go文件都属于这个http包,所以我们使用http包里的函数、接口的时候，导入这个http包就可以了。



### 模块 module 

一个 go module 是一组树形结构的 package ，并在其根目录有 go.mod 文件。go.mod 文件定义了 module 路径。

根目录下的 go.mod 文件定义了模块路径：包的导入路径，以及它依赖的项目

一个模块并不一定要推到远程仓库，它可以仅仅放在本地，但是规划一个好的模块路径通常是好习惯。

一个 go 模块不仅仅是做为他们里面的包的导入前缀，同样也要很清楚的描述出，go 命令可以去哪里下载他们。

例如：为了下载 golang.org/x/tools 这样一个 module ，go 命令可以知道很容易的定位到这个仓库：https://golang.org/x/tools







### Main包

在 go 中，命名为 main 的包具有特殊含义，Go 语言的编译程序会试图把这种名字的包编译为二进制可执行文件。

**所有用 Go 语言编译的可执行程序都必须有一个名叫 main 的包。**

**在 go 语言里，同时要满足`main`包和包含`main()`函数，才会被编译成一个可执行文件。**

main 函数是程序入口。程序编译时，**会使用声明 main 包的代码所在的目录的目录名作为二进制可执行文件的文件名。**

```go
//  $GOPATH/src/hello/main.go

package main

import "fmt"

func main() {
	fmt.Println("Hello World!")
}

// 终端进到hello目录下，go build 

// 这条命令执行完后，会生成一个二进制文件。
// 在 UNIX、Linux 和 Mac OS X 系统上，这个文件会命名为 hello，
// 而在 Windows 系统上会命名为 hello.exe。可以执行这个程序，并在控制台上显示“HelloWorld!”。

// 如果将包名改为非 
```



### 导包

每个语言都有导包机制，golang 也不例外，在 go 源文件中，使用 import 关键字来导包。

如果你的包引入了三种类型的包，标准库包，程序内部包，第三方包，建议采用如下方式进行组织你的包:

- 标准库包（有超过一百多个包，使用 go list std 列出所有标准库包）
- 程序内部包 从 gopath 环境变量的路径中查找
- 第三方包 

**导包优先级： go 编译器读到一个 import 关键字导包的时候，按照上述顺序导入，一旦找到满足要求的，就停止查找。**

```go
// 标准库包  /usr/local/go/src/pkg/net/http
// 内部包   /home/myproject/src/net/http
// 第三方包 /home/mylibraries/src/net/http

// 编译器会使用 Go 环境变量设置的路径，通过引入的相对路径来查找磁盘上的包。标准库中的包会在安装 Go 的位置找到。

// 导包方法
// 导一个包，标准库中的包
import "fmt"


//导多个包
import (
   "fmt"
   "os"
)


// 导当前工程下的自定义包
import "pk1/pk2"



// 导包规范：有顺序的引入包, 不同的类型采用空格分离:
	// 第一种是标准库    /usr/local/go/src/net/http
	// 第二种是项目包    /home/myproject/src/net/http
	// 第三种是第三方包。可以远程导入，导入路径是一个远程URL，使用 go get 下载到 gopath/src/github.com/astaxie/beego 这个路径
import (
    "encoding/json"
    "strings"

    "myproject/models"
    "myproject/controller"
    "myproject/utils"

    "github.com/astaxie/beego"
    "github.com/go-sql-driver/mysql"
)
```

#### 导包别名

在导很长的包名时，使用简单的别名方式来缩短引用。

```go
// 导外部包取一个别名，调用这个外部包的导出函数时，使用 别名.函数名 的格式调用
import dg "github.com/bwmarrin/discordgo"

func main() {
    err := dg.New()
}

// 既需要 network/convert 包来转换从网络读取的数据，又需要 file/convert 包来转换从文本文件读取的数据时，就会同时导入两个名叫 convert 的包。

// 导包避免冲突，当两个包有一样的名字时，可以取一个别名来处理冲突问题
// 引用包内变量和函数时，可以使用包别名来引用
import (
    "math/rand"
    crand "crypto/rand"  
)
```

#### 空导入

在 golang 中，**`导入一个包而不用`和`函数内声明变量但是并不使用`一样**，都会编译错误。

这是一个非常好的规则，因为这样可以避免我们引用很多无用的代码而导致的代码臃肿和程序的庞大，因为很多时候，我们都不知道哪些包是否使用。

这在 C 和 Java 上会经常遇到，有时候我们不得不借助工具来查找我们没有使用的文件、类型、方法和变量等，把它们清理掉。

```go
// 如果导入一个包，却不引用其中的变量和函数，编译报错
//  imported and not used: "math/rand" 
import (
    "fmt"
    "math/rand"
    crand "crypto/rand"
)
func main() {
    fmt.println("Go is great!")
}



// 有时候，我们需要导入一个包，但是又不使用它，按照规则，这是不行的，为此Go语言给我们提供了一个空白标志符_
// 只需要我们使用 _ 重命名我们导入的包就可以了。使用 _ 的方式来导入未被引用到的包，也可以编译通过，表示暂时不会用到这个包，后续可能会用到。
import (
    "fmt"
    _ "math/rand"
    _ "crypto/rand"
)
func main() {
    fmt.println("Go is great!")
}


```

#### 包的初始化

包的初始化首先是解决包级变量的依赖顺序，然后按照包级变量声明出现的顺序依次初始化：

```go
var a = b + c  // a 第三个初始化, 为 3
var b = f()    // b 第二个初始化, 为 2, 通过调用 f (依赖c)
var c = 1      // c 第一个初始化, 为 1

func f() int { 
    return c + 1
}
```

如果想要构建一个程序，则包和包内的文件都必须以正确的顺序进行编译。包的依赖关系决定了其构建顺序。

属于同一个包的源文件必须全部被一起编译，一个包即是编译时的一个单元，因此根据惯例，每个目录都只包含一个包。

**如果对一个包进行更改或重新编译，所有引用了这个包的客户端程序都必须全部重新编译。**

Go 中的包模型采用了显式依赖关系的机制来达到快速编译的目的。



### init 函数

如果包中含有多个 .go 源文件，它们将按照发给编译器的顺序进行初始化，Go语言的构建工具首先会将  .go 文件根据文件名从小到大排序，然后依次调用编译器编译。

对于在包级别声明的变量，如果有初始化表达式则用表达式进行初始化，还有一些没有初始化表达式的，例如某些表格数据初始化并不是一个简单的赋值过程。

在这种情况下，我们可以用一个特殊的 `init` 初始化函数来简化初始化工作。

**每个文件都可以包含多个 `init` 初始化函数**:

```go
func init() { /* ... */ }
```

**这样的 `init` 初始化函数除了不能被直接调用或引用外，其他行为和普通函数类似。**

**在每个文件中的 `init` 初始化函数，在程序开始执行时按照它们声明的顺序被自动调用。**

init函数通常用来做初始化变量、设置包或者其他需要在程序执行前的引导工作。

**比如上面我们讲的需要使用`_`空标志符来导入一个包的目的，就是想执行这个包里的init函数。**

**每个包可以包含任意多个 init 函数，这些函数都会在程序执行开始的时候被调用。**

每个包在解决依赖的前提下，以导入声明的顺序初始化，每个包只会被初始化一次。

因此，如果一个 p 包导入了 q 包，那么在 p 包初始化的时候可以认为 q 包必然已经初始化过了。

**初始化工作是自下而上进行的，main 包最后被初始化。以这种方式，可以确保在 main 函数执行之前，所有依赖的包都已经完成初始化工作了。**

```go
// 我们以数据库的驱动为例，Go语言为了统一关于数据库的访问，使用databases/sql抽象了一层数据库的操作
// 可以满足我们操作 MySQL、PostgreSQL 等数据库，这样不管我们使用这些数据库的哪个驱动，编码操作都是一样的。
// 想换驱动的时候，就可以直接换掉，而不用修改具体的代码
// github.com/go-sql-driver/mysql 这个包中的一个 init 函数

package mysql

import (
	"database/sql"
)

func init() {
	sql.Register("mysql", &MySQLDriver{})
}



// 在业务代码中导入sql包
// 因为我们只是想执行这个mysql包的init方法，并不想使用这个包，所以我们在导入这个包的时候，需要使用_重命名包名，避免编译错误。

import "database/sql"
import _ "github.com/go-sql-driver/mysql"

db, err := sql.Open("mysql", "user:password@/dbname")

```





### 标准库



fmt 包是来自于Go 的**标准库**。在 Go 的安装目录中的 src 目录下包含了一些可以直接使用的包，即标准库。





```shell
bin
pkg
src
　　pk1
　　　　pk2
　　　　　　function1.go
　　　　　　function2.go
　　index.go
```



```go
// function1.go
package  pk3

func  Function_test3()  {
    	println("function_test3")
}
```

```go
// function2.go
package  pk3
import (
	"fmt"
)

func  Function_test4()  {
     	fmt.println("function_test4")
}
```

```go
// index.go
package main
import (
    "fmt"
    "pk1/pk2"
    
)
func main() {
    pk3.Function_test4()
}
```



**包的嵌套**



**1、import 导入的参数是路径，而非包名。**

**1、尽管习惯将包名和目录名保证一致，但这不是强制规定；**

**2、在代码中引用包成员时，使用包名而非目录名；**

**3、同一目录下，所有源文件必须使用相同的包名称（因为导入时使用绝对路径，所以在搜索路径下，包必须有唯一路径，但无须是唯一名字）；**

**4、至于文件名，更没啥限制（扩展名为.go）;**





### 其他包

在开发过程中可能会遇到这样的情况，有一些包是引入自不同地方的，比如：

```go
import (
	golang.org/x/net/html
	net/html
)
```









## 注释

Go语言支持C风格的块注释 `/* */` 和C++风格的行注释 `//`。 行注释更为常用，而块注释则主要用作包的注释，当然也可在禁用一大段代码时使用。

注释有两种形式：

1. **行注释**以 `//` 开始，至行尾结束。一条行注释视为一个换行符。
2. **块注释** 以 `/*` 开始，至 `*/` 结束。 块注释在包含多行时视为一个换行符，否则视为一个空格。

注释不可嵌套。

### 包注释

每一个包应该有相关注释，在 package 语句之前的块注释将被默认认为是这个包的文档说明，其中应该提供一些相关信息并对整体功能做简要的介绍。

一个包可以分散在多个文件中，但是只需要在其中一个进行注释说明即可。

当开发人员需要了解包的一些情况时，自然会用 godoc 来显示包的文档说明。

在首行的简要注释之后可以用成段的注释来进行更详细的说明，而不必拥挤在一起。另外，在多段注释之间应以空行分隔加以区分。



```go
// Package superman implements methods for saving the world.
//
// Experience has shown that a small number of procedures can prove
// helpful when attempting to save the world.
package superman


```

### 变量注释

几乎所有全局作用域的类型、常量、变量、函数和被导出的对象都应该有一个合理的注释。如果这种注释（称为文档注释）出现在函数前面

```go
// enterOrbit causes Superman to fly into low Earth orbit, a position
// that presents several possibilities for planet salvation.
func enterOrbit() error {
   ...
}

```



`go doc` 工具会从 Go 程序和包文件中提取顶级声明的首行注释以及每个对象的相关注释，并生成相关文档。

它也可以作为一个提供在线文档浏览的 web 服务器，[golang.org](http://golang.org) 就是通过这种形式实现的。

```go
go doc package 
// 获取包的文档注释，例如：go doc fmt 会显示使用 godoc 生成的 fmt 包的文档注释。

go doc package/subpackage 
// 获取子包的文档注释，例如：go doc container/list

go doc package function 
// 获取某个函数在某个包中的文档注释，例如：go doc fmt Printf 会显示有关 fmt.Printf() 的使用说明。
```



## 命名规范

命名在任何语言中都是相当重要的，在 go 中，命名可以直接影响到语义。

与 java 不同，go 没有 public private 等关键字来修饰变量或方法。例如，某个变量名称在包外是否可见，就取决于其首个字符是否为大写字母。



包名规范惯例：

- 包名小写，不使用下划线或驼峰记法。（`err` 的命名就是出于简短考虑的）
- 包名应为其源码目录的基本名称，在 src/pkg/encoding/base64 中的包应作为 "encoding/base64" 导入，其包名应为 base64 。
- 

golang 中 **函数、变量、常量、类型、语句、包名** 都遵循如下规则：

- 包名小写，包名没有大写或下划线。

- 字母或下划线开头，并区分大小写。
- 单词组合名称时，使用驼峰命名法，例如：标准库中的函数使用 OuoteRuneToASCII 这种命名方法。
- go 风格命名简洁，名称的作用域越大，就使用越长越有意义的名称
- 

**实体作用域**

- 函数内的实体函数内可见
- 函数外的实体，包内所有源文件都可见
- 实体的第一个字母的大小写决定是否跨包可见：大写表示导出的，包外可见，小写包内可见。
- 其实就是面向对象语言中的 public ， private 概念



## 变量

**golang是一个强类型语言，变量在声明的时候，必须要确定其类型。**

从根本上说，变量相当于是对一块数据存储空间的命名，程序可以通过定义一个变量来申请一块数据存储空间，之后可以通过引用变量名来使用这块存储空间。

**Go 和许多编程语言不同，它在声明变量时将变量的类型放在变量的名称之后。Go 为什么要选择这么做呢？**

https://tonybai.com/2012/10/11/understanding-go-declaration-syntax/

首先，它是为了避免像 C 语言中那样含糊不清的声明形式，例如：`int *a, b;`。在C语言这个例子中，只有 a 是指针，而 b 不是。

如果你想要这两个变量都是指针，则需要将它们分开书写（你可以在 Go 语言的 [声明语法](https://blog.golang.org/declaration-syntax) 页面找到有关于这个话题的更多讨论）。



使用 var 关键字来声明变量，变量声明的通用格式如下：

```go
// 变量声明初始化并赋值：var关键字表示声明变量，name为变量名，type为变量数据类型，expression为变量表达式
var name type = expression 

// https:////blog.golang.org/gos-declaration-syntax
// Rob Pike 曾经在Go官方博客解释过: 为什么要把数据类型放在后面

// 声明多个变量
var a int
var b bool
var str string

// 声明多个同样类型变量
var (
	v1 int
	v2 string
)


// 完整的变量声明并赋值
var a int = 15
var b bool = false
var str string = "Go says hello to the world!"

// 类型推导式的声明并赋值
// 这有点像 Ruby 和 Python 这类动态语言，只不过它们是在运行时进行推断，而 Go 是在编译时就已经完成推断过程。
// go是一个不折不扣的强类型语言
var a = 15
var b = false
var str = "Go says hello to the world!"

// 将多个变量合在一个var块里面
var (
    a = 15
    b = false
    str = "Go says hello to the world!"
    numShips = 50
    city string
)

// Go编译器可以根据变量的值来自动推断其类型，这有点像 Ruby 和 Python这类动态语言，只不过他们是在运行时进行推断，而 Go 是在编译时就已经完成推断过程。
// 自动推断类型并不是任何时候都适用的，当你想要给变量的类型并不是自动推断出的某种类型时，你还是需要显式指定变量的类型
// 变量的类型也可以在运行时实现自动推断: 这种写法主要用于声明包级别的全局变量，当你在函数体内声明局部变量时，还是应使用简短声明语法:=
var (
    HOME = os.Getenv("HOME")
    USER = os.Getenv("USER")
    GOROOT = os.Getenv("GOROOT")
)

```

类型和表达可以省略一部分，但是不能都省略：

- 如果省略类型，那么将根据初始化表达式来推导变量的类型信息。变量类型推导。

- 如果省略表达式，变量类型由 **type** 类型决定，其初始值是该类型的**零值**。

  - 数字类型的零值是0。
  - 接口和引用类型（slice，指针，map，通道，函数）的零值是 nil 
  - 对于结构体或数组这样的复合类型，零值是其所有元素或成员的零值。

**所以 golang 中不存在未初始化的变量**。零值机制保证了所有的变量都是良好定义的。**记住，所有的内存在 Go 中都是经过初始化的。**

声明变量列表：

```go
// 声明三个int类型的变量 i,j,k
var i,j,k int   
// 声明三个不同类型的变量
var b,f,s = true , 2.3 , 'four' 
```

**包级别的变量在 main 开始之前就进行了声明和赋值。**



### 多重赋值

Go语言的变量赋值与多数语言一致，但是引入了C/C++程序员期盼多年的多重赋值功能：

```go
// 在 go 中交换两个变量的值
i, j = j, i

// 在不支持多重赋值的语言中，交互两个变量的内容需要引入一个中间变量
t = i; i = j; j = t;
```



### 短变量(短声明)

在函数中，可以使用短变量的形式来**声明**和**初始化**局部变量。使用如下格式：

```go
// 不需要var关键字，也不需要后面的类型名，Go编译器可以从初始化表达式的右值推导出该变量应该声明为哪种类型
name := expression
```

**短变量主要用于局部变量声明。带 var 关键字的一般用于全局变量**

多变量声明也可以用短声明的方式进行声明：

```go
// 直接短声明两个变量
i,j := 0,1

// os.Open函数调用将返回两个值
f,err := os.Open(name)

// 短声明中也可以混带赋值,对于s来说，这是声明并赋值，对于i来讲，因为前面已经声明过了，这就是赋值操作。
s,i := 1,0



// 短声明中最少要有一个变量是新声明，下面的代码将不能编译通过
f , err := os.Open(infile)
// ...
f , err := os.Create(outfile) // compile error: no new variables

// 解决的办法就是把第二个短声明改成普通的多重赋值


// 短声明语句只有对已经在同级词法域声明过的变量才和赋值操作语句等价，如果变量是在外部词法域声明的，那么简短变量声明语句将会在当前词法域重新声明一个新的变量。

```

`:=` 是一个声明动作，`=` 是一个赋值动作。多变量声明不能与**多重赋值**搞混：

```go
// 多重赋值，交换i和j的值
i , j = j , i
```







### 变量的内存大小





### 指针

普通变量在声明语句创建时被绑定到一个变量名，比如  `var  x int = 1` ，声明一个变量 x ，在内存中的值是 1。

指针，是一个变量的地址，使用指针，可以在不知道变量名的情况下，直接读取或操作变量值。

声明一个整形变量 `var x int`，那么表达式 &(x)  就是指向 x 这个整型变量的指针。这个表达式的类型就是整型指针（*int）。

如果这个整形指针叫做 p , 那么就说 p 指向 x , 或 p 包含 x 的地址，p 指向的变量写作 *p  。

```go
//  /go-demo/pointer.go

package main

import (
    "fmt"
    "reflect"
)

func main() {
    
    // 声明两个整型变量a,b
    // 两个指针变量cd，分别指向ab的内存地址
    var (
    	a int32 = 1
    	b int = 2
        c = &b 
        d = &c
    )
    // 打印变量a,b的值
    fmt.Println(a,b)
    // 创建一个指针c，存放变量b的地址
    // var c = &b 
    // 创建一个指针d，存放指针c的地址
    // var d = &c
    
    *c = 3
    fmt.Println(a,b,c,d)
    fmt.Println("the type of a is :", reflect.TypeOf(a))
    fmt.Println("the type of b is :", reflect.TypeOf(b))
    fmt.Println("the type of c is :", reflect.TypeOf(c))
    fmt.Println("the type of d is :", reflect.TypeOf(d))

}


// 在 Linux 上编译并执行
root@vpsServer:~# go run /go-demo/pointer.go
1 2
1 3 0xc00001a088 0xc00000e038
the type of a is : int32
the type of b is : int
the type of c is : *int
the type of d is : **int
root@vpsServer:~#



// 打印变量 a , b ，是打印变量 a b 的值.
// 创建一个指针c，存放int变量b的地址，这个指针的数据类型是 *int，表示它是一个指针，指向了一个int类型的变量  
// 通过 *c 来取这个指针所指向变量，就相当于取b，相当于给b重新赋值。
// 重新打印 a,b,c 打到b的新值，打印指针c，是变量b在内存中的地址。
// 打印 a,b,c 的类型
// d是指针嵌套，指针的指针

```

指针类型的零值是 nil , 判断指针是否为 nil ，可以判断指针是否指向一个变量。

**当前仅当两个指针指向同一个变量或者两个指针都是 nil 的情况下才相等。**

```go
var x , y int
fmt.Println(&x == &x , &x == &y, &x == nil ) // "true false false"
```

  ```go

// 声明一个指针变量，将函数调用结果赋给这个指针。
var p = f()

// 函数的返回类型是指针，每次调用时，函数内短声明一个变量，每次调用返回这个变量的地址。
func f() *int {
    v := 1 
    return &n
}
// 每次调用f都返回不同的值。
fmt.Println(f() == f())  // "false"
  ```



```go
// golang中没有指针运算， *p++ ，它表示 (*p)++ ：首先获取指针指向的值，然后对这个值加1，这与C中有区别。
// 因为指针包含的是变量的值，所以把指针传参给函数，能够让函数间接更新指针指向的变量的值。
// 函数返回值为int类型，函数传参为指向int类型的指针

// 对于Go语言，严格意义上来讲，只有一种传递，也就是按值传递(by value)。
// 当一个变量当作参数传递的时候，会创建一个变量的副本，然后传递给函数或者方法，你可以看到这个副本的地址和变量的地址是不一样的。
// 当一个指针当作参数传递的时候，一个新的指针被创建，它指向变量指向的同样的内存地址。你可以将这个指针看成原始变量指针的副本。
// 我们就可以理解成Go总是创建一个副本按值转递，只不过这个副本有时候是变量的副本，有时候是变量指针的副本。

// 这个函数传参指针，返回值是int类型的变量
func incr (p *int) int {
	
    *p++
    rerurn *p
}

v := 1    // 短声明一个变量v，并赋值
incr(&v)  // &v取这个变量的指针，也就是这个变量在内存中的地址，将这个变量的地址做为指针传参进上面那个函数，
fmt.Println(incr(&v))  //"3" v现在是3 


// 每次使用变量的地址，或者是复制一个指针，我们就相当于给变量创建了一个"别名"。例如 p* 是 v 的别名。
// 这种别名方式是很有用的。但同时也是双刃剑：
// 为了找到所有访问变量的语句，需要知道找到所有别名。找到指针比找到变量名要更复杂。
```





```go
// gopl.io/ch2/echo4
package main 

import (
	"flag"
    "fmt"
    "strings"
)

// flag.Bool 函数创建一个新的 bool 标识变量。它有三个参数:"标识名","变量默认值","当用户提供非法参数的提示消息"
// n表示这个变量的指针，n* 表示这个变量的值
var n = flag.Bool("n", false, " omit tailing newline")
var sep = flag.String("s" ,"" , "seprator")

func main (){
    // 更新标识变量的默认值
    // 非标识参数，使用 flag.Args 返回的字符串slice来访问
    flag.Parse()
    fmt.Pirntln(strings.Join(flag.Args(),*sep))
    if !*n {
        fmt.Println()
    }  
}


```

### new() 函数创建变量



另一种创建变量的方式是使用内置的 new 函数，new(T)函数是一个分配内存的内建函数。

表达式` new(T)` 创建一个未命名的 `T 类型变量`，初始化为 T 类型的零值，并返回其地址。



与C++不一样的是，它并不初始化内存，只是将其置零。也就是说，new(T)会为T类型的新项目，分配被置零的存储，并且返回它的地址，一个类型为*T的值。

在Go的术语中，其返回一个指向新分配的类型为T的指针，这个指针指向的内容的值为零（zero value）。注意并不是指针为零。



**所以 new() 函数返回的是一个指针**

```go
// 当你动态申请内存的时候，指针的存在意义之一就被体现出来了，此时并没有变量能直接指向这块内存，所以只能通过内存地址来访问

// 声明一个int变量，这个变量没有变量名，所以只能赋值给一个指针p,这个时候p是一个指针。
p := new(int)

// 通过 *p 取变量值，打印0
fmt.Println(*p)

// 将2赋值给这个指针
*p = 2

// 打印2
fmt.Println(*p)

// 使用 new() 函数创建的变量和取其地址的普通变量没什么区别。只是不需要引入变量名，通过 new(t) 就可以直接在表达式中使用。
// 下面这两个函数等价

func newInt() *int {
    return new(int)
}

func newInt() *int {
    var dummy int 
    return &dummy
}

// 每次调用 new 都返回一个具有唯一地址的不同变量。
p := new(int)
q := new(int)
fmt.Println(p == q)  // false


// new 是一个预声明的函数，而不是一个关键字。所以可以在自己的函数内重定义为其他的类型，在这个函数内就不能使用预声明的内置new函数
func delta (old, new int ) int {
    return new - old 
}

```

### 变量的生命周期

变量的生命周期是指程序执行过程中变量有效存在的时间段。对于包级别的变量，它们的生命周期和整个程序的运行周期是一致的。

局部变量的有一个动态的生命周期。每次从创建一个新变量的声明语句开始，直到该变量不再被引用为止，然后变量的存储空间可能被回收。函数的参数变量和返回值变量都是局部变量。它们在函数每次被调用的时候创建。



#### 栈内存

栈 可以简单得理解成一次函数调用内部申请到的内存，它们会随着函数的返回把内存还给系统。

```go

func F() {
	temp := make([]int, 0, 20)
	...
}
// 类似于上面代码里面的temp变量，只是内函数内部申请的临时变量，并不会作为返回值返回，它就是被编译器申请到栈里面。
```



**申请到 栈内存 好处：函数返回直接释放，不会引起垃圾回收，对性能没有影响。**





#### 堆内存

这段代码，与上面一样，只是申请后作为返回值返回了，编译器会认为变量之后还会被使用，当函数返回之后并不会将其内存归还，那么它就会被申请到 **堆内存空间** 上面了。

申请到堆上面的内存才会引起垃圾回收，如果这个过程（特指垃圾回收不断被触发）过于高频就会导致 gc 压力过大，程序性能出问题。

```go
func F() []int{
	a := make([]int, 0, 20)
	return a
}
```



```go
func F() {
    a := make([]int, 0, 20)     // 栈 空间小
    b := make([]int, 0, 20000) // 堆  空间过大
 
	l := 20
	c := make([]int, 0, l)  // 堆 动态分配不定空间
}

// 像是 b 这种 即使是临时变量，申请过大也会在堆上面申请。
// 对于 c 编译器，对于这种不定长度的申请方式，也会在堆上面申请，即使申请的长度很短。
```



#### 逃逸分析



> 所谓逃逸分析（Escape analysis）是指由编译器决定内存分配的位置，不需要程序员指定。

在函数中申请一个新的对象：

- 如果分配 在栈中，则函数执行结束可自动将内存回收；
- 如果分配在堆中，则函数执行结束可交给GC（垃圾回收）处理;

> 注意，对于函数外部没有引用的对象，也有可能放到堆中，比如内存过大超过栈的存储能力。





```go
// 这里 x 使用堆内存空间，因为它在f函数返回后，还可以从 Global 变量访问，这种情况被称为 x 从 f 中逃逸。

var Global *int 
func f(){
    var x int 
    x = 1 
    Global = &x 
}
```

### 变量赋值

```go
// 用欧几里得算法计算两个整数的最大公约数，多重赋值
func gcd(x , y int) int {
    for y!= 0 {
        x , y = y , x % y
    }
    return y
}

// 计算
```



### 匿名变量

我们在使用传统的强类型语言编程时，经常会出现这种情况，在调用函数时为了获取一个值，却因为该函数返回多个值而不得不定义一堆没用的变量。

在Go中这种情况可以通过结合使用多重返回和匿名变量来避免这种丑陋的写法，让代码看起来更加优雅。

```go
// 假设 GetName 函数返回三个值， 分别为 firstName，lastName 和 nickName
func GetName() (firstName, lastName, nickName string) {
	return "May", "Chan", "Chibi Maruko"
}
// 如果只想获得 nickName ，则函数调用语句可以用如下方式编写
_, _, nickName := GetName()
```



### 获取变量数据类型

在 golang 中获取变量的数据类型，使用反射：

```go
// 获取变量数据类型方法1：通过反射
package main

import (
    "fmt"
    "reflect"
)

func main() {
    var x int32 = 20
    fmt.Println("the type of x is :", reflect.TypeOf(x))
}

// 获取变量数据类型方法2：自定义typeof方法

package main

import "fmt"

func typeof(v interface{}) string {
    return fmt.Sprintf("%T", v)
}

func main() {
	var a = 234
	fmt.Print(typeof(a))
}

```



## 常量

在程序编译期间，就已知且不能修改的量。

一般使用 `const`  关键字定义，存储在常量中的数据类型只可以是布尔型、数字型（整数型、浮点型和复数）和字符串型。

### 字面常量

所谓字面常量（literal），是指程序中硬编码的常量。

在其他语言中，常量通常有特定的类型，比如 `-12` 在C语言中会认为是一个 int 类型的常量。如果要指定一个值为`-12`的 long 类型常量，需要写成 `-12l`。

Go语言的字面常量更接近我们自然语言中的常量概念，它是无类型的。只要这个常量在相应类型的值域范围内，就可以作为该类型的常量。



Go的常量定义可以限定常量类型，但不是必需的。如果定义常量时没有指定类型，那么它与字面常量一样，是无类型常量。

比如 -12 可以赋给 ` int 、 uint 、 int32 、` `int64 、 float32 、 float64 、 complex64 、 complex128 ` 等类型的变量。

常量定义的右值也可以是一个在编译期计算的常量表达式，如：

```go
const mask = 1 << 3
```

由于常量的赋值是一个编译期行为，所以右值不能出现任何需要运行期才能得出结果的表达式，比如试图以如下方式定义常量就会导致编译错误。

```go
// 编译错误， os.GetEnv() 只有在运行期才能知道返回结果，在编译期并不能确定，所以无法作为常量定义的右值。
const Home = os.GetEnv("HOME")
```



```go
// 声明一个常量
const pi = 3.1415926
// 批量声明多个常量
const （
	statusOK = 200
	notFound = 404
）
// 如果批量声明多个常量，后面的常量没有赋值，则取前面的常量值
const (
	n1 = 100
    n2
    n3
)

```

#### 字符串字面量

**Go语言中的字符串字面量使用 双引号 或 反引号 来创建** ：

- 双引号用来创建 **可解析的字符串字面量** (支持转义，但不能用来引用多行)；Interpreted string
- 反引号用来创建(raw string)，这些字符串可能由多行组成(不支持任何转义序列)，原生的字符串字面量多用于书写多行消息、HTML以及正则[表达式](http://www.07net01.com/tags-表达式-0.html)。



### 常量计数器

`iota` 是一个常量计数器，只能在常量的表达式中使用。

在每一个 const 关键字出现时被重置为0。然后在下一个 const 出现之前，每出现一次 iota ，其所代表的数字会自动增1。

```golang
const ( 			// iota被重设为0
	c0 = iota 		// c0 == 0
	c1 = iota 		// c1 == 1
	c2 = iota 		// c2 == 2
)

const (
	a = 1 << iota 	// a == 1 (iota在每个开头被重设置为0)
	b = 1 << iota 	// b == 2
	c = 1 << iota 	// c == 4
)

const (
	u = iota * 42 			// u == 0
    v float64 = iota * 42 	// v == 42.0
    w = iota * 42 			// w == 84
)

const x = iota // x == 0 (因为为iota又被重设为0)
const y = iota // y == 0 (同上)
```







 

### 枚举

枚举指一系列相关的常量，比如下面关于一个下星期中每天的定义。const 后跟一堆圆括号的方式定义一组常量。

```go
const (
	Sunday = iota 
    Monday
	Tuesday
	Wednesday
	Thursday
	Friday
	Saturday
	numberOfDays  // 这个常量通常不导出
)
```





## 数据类型



Go语言内置以下这些基础类型：

- 布尔类型: bool
- 整型： int8 、 byte 、 int16 、 int 、 uint 、 uintptr 等
- 浮点类型： float32 、 float64 
- 复数类型： complex64 、 complex128
- 字符串类型： string
- 字符类型： rune
-  错误类型： error



此外，Go语言也支持以下这些复合类型：

- 数组
- 切片
- 指针
- 字典
- 通道
- 结构体
- 接口



### 布尔类型



### 字符串类型



```go



// Go编译器支持UTF-8的源代码文件格式。这意味着源代码中的字符?可以包含非ANSI的字符，比如“Hello world. 你好，世界！”可以出现在Go代码中。
// 但需要注意的是，如果你的Go代码需要包含非ANSI字符，保存源文件时请注意编码格式必须选择UTF-8
// 字符串的编码转换是处理文本文?（比如TXT、XML、HTML等）非常常见的需求，不过可惜的是Go语言仅支持UTF-8和Unicode编码。对于其他编码，Go语言标准库并没有内置的编码转换支持。



```





## 自定义数据类型（type关键字）

`type` 声明为定义一个新的`命名类型`，它和某个已知的类型使用同样的`底层类型`，它的格式如下：

```
type name underlying-type
```

类型的声明通常出现在包级别，一般在整个包内都可以可见，如果名字是导出的（开头大写），其他的包也可以访问到。

> 译注：对于中文汉字，Unicode标志都作为小写字母处理，因此中文的命名默认不能导出；
>

```go
// 进行华氏温度和摄氏温度的转换计算

// 这个包定义两个类型：摄氏温度类型和华氏温度类型，它们的底层类型都是float64
// 新建三个摄氏温度类型的常量：绝对零度，结冰点温度，沸水温度
// CToF和FToC两个函数，分别接收不同类型的参数，并经过计算后，再进行转型操作。

package tempconv

import "fmt"

type Celsius float64
type Fahrenheit float64


const (
	AbsoluteZero Celsisus = -273.15
    FreezingC    Celsisus = 0
    BoilingC     Celsisus = 100
)

func CToF(c Celsius) Fahrenheit {
    return Fahrenheit(c*9/5 + 32)
}

func FToC(f Fahrenheit) Celsius {
    return Celsius((f - 32) * 5 / 9)
}



```

**对于每个类型 T，都有一个类型转转操作T(x)，用于将 x 转换为 T 类型，如果 T 是指针，可能需要 (*int) (0) 这种格式。**

**只有当两个类型的底层基础类型相同时，才允许这种转型操作，或者是两者都是指向相同底层结构的指针类型**

**底层数据类型决定了内部结构和表达方式，也决定是否可以像底层类型一样对内置运算符的支持。这意味着，Celsius和Fahrenheit类型的算术运算行为和底层的 float64 类型是一样的**。

```go
// 两个Celsisus类型的常量相减，得到"100" 
fmt.Printf("%g\n", BoilingC-FreezingC) // "100" °C
// 调CToF函数，返回Fahrenheit类型的值赋给boilingF变量
boilingF := CToF(BoilingC)
// 两个Fahrenheit类型的变量进行操作
fmt.Printf("%g\n", boilingF-CToF(FreezingC)) // "180" °F
// 编译报错，Fahrenheit类型的变量不能与Celsisus类型的常量直接计算，compile error: type mismatch
fmt.Printf("%g\n", boilingF-FreezingC) 
```











## 基本数据类型



### 整型

#### 无符号整型

| Type  | Size                                 | Range              |
| :---- | :----------------------------------- | :----------------- |
| int8  | 8 bits      （8个二进制位），1个字节 | -128 to 127        |
| int16 | 16 bits   （16个二进制位），2个字节  | -2^15 to 2^15 -1   |
| int32 | 32 bits    （16个二进制位），4个字节 | -2^31 to 2^31 -1   |
| int64 | 64 bits    （64个二进制位），8个字节 | -2^63 to 2^63^ -1  |
| int   | Platform dependent                   | Platform dependent |

#### 有符号整型

| Type   | Size               | Range              |
| :----- | :----------------- | :----------------- |
| uint8  | 8 bits             | 0 to 255           |
| uint16 | 16 bits            | 0 to 2^16 -1       |
| uint32 | 32 bits            | 0 to 2^32 -1      |
| uint64 | 64 bits            | 0 to 2^64 -1      |
| uint   | Platform dependent | Platform dependent |

```go

// 与平台有关的整型（32位架构或64位架构）
uint     	// either 32 or 64 bits  
int      	// same size as uint   即使在某一个架构中，int 和 int32 类型的变量有一样二进制位数，但是它们还是不是一样的类型

// 通常声明一个整型变量，大多数都是 int 类型
var i = 123 // i的类型是int类型


```



### 整型字面量

**二进制（binary）**

使用前缀 `0b` 或 `0B` 来表示二进制数，如 `0b0010` 

**八进制（octal）**

使用前缀 `0o` 或 `0O` （前面是数字零，后面是字母欧）来表示八进制数，如 `0o70`

**十六进制**

使用前缀 `0x` or `0X` 来表示十六进制数，如 



为了可读性，在进制前缀和后面的数字之间，可以加上 `_` 这样的下划线来区分。

```go
package main

import "fmt"

func main() {
	// 十六进制以0x_前缀开头表示
	var i1 = 0x_ff
	// 十进制正常表示
	var i2 = 100
	// 八进制以0o_前缀开头
	var i3 = 0o_177
	// 二进制以0b_前缀开头
	var i4 = 0b_00001011
	// 格式化输出时，%d 占位符表示十进制(decimal)
	fmt.Println("十进制打印")
	fmt.Printf("i1= %d %T\n", i1, i1)
	fmt.Printf("i2= %d %T\n", i2, i2)
	fmt.Printf("i3= %d %T\n", i3, i3)
	fmt.Printf("i4= %d %T\n", i4, i4)
	fmt.Println()
	// 格式化输出时，%o 占位符表示八进制(octal)
	fmt.Println("八进制打印")
	fmt.Printf("i1= %o %T\n", i1, i1)
	fmt.Printf("i2= %o %T\n", i2, i2)
	fmt.Printf("i3= %o %T\n", i4, i4)
	fmt.Println()
	// 格式化输出时，%x 占位符表示十六进制(hexadecimal)
	fmt.Println("十六进制打印")
	fmt.Printf("i1= %x %T\n", i1, i1)
	fmt.Printf("i2= %x %T\n", i2, i2)
	fmt.Printf("i3= %x %T\n", i3, i3)
	fmt.Printf("i4= %x %T\n", i4, i4)
	fmt.Println()
}

// 程序输出：

// 十进制打印
// i1= 255 int
// i2= 100 int
// i3= 127 int
// i4= 11 int

// 八进制打印
// i1= 377 int
// i2= 144 int
// i3= 13 int

// 十六进制打印
// i1= ff int
// i2= 64 int
// i3= 7f int
// i4= b int


```



### 字符类型/符文

严格来说，这并不是 Go 语言的一个类型，字符只是整型的特殊用例。

在 golang 中，字符串中的每一个元素叫做 【字符】，在遍历或者单个获取字符串元素时可以获得字符。

在 golang 中，其实没有 char 这种字符类型的，我们声明的 'A' , '中' 这种字符常量（Rune literals），其数据类型实际上是 int32  

 byte 和 rune 类型实际上是 uint8 和 int32 的类型别名。Go 语言将 `rune` 定义为 `int32` 类型的别名，它们在功能上完全相同，但是语义不同，`rune` 可以更清楚地用整型值来表示码点。

- **byte**，占用1个节字，共 8 个比特位，它和 `uint8` 类型本质上没有区别，它表示的是 ACSII 表中的一个字符。
- **rune**，占用4个字节，共 32 个比特位，它和 `int32` 本质上也没有区别。它表示的是一个 Unicode 字符。`rune` 可以更清楚地用整型值来表示码点。



```go
// byte类型相关示例

// var a byte = 65              // 在 ASCII 码表中，A 的值是 65，十进制表示
// var a byte = '\101'  		// 65的八进制写法
// var c byte = '\x41'  		// 十六进制写法

var a = 'A'                     // 英文字符的字面常量
fmt.Println(a)         			// unicode编码：65
fmt.Println(reflect.TypeOf(a)) 	// 英文字符的类型：int32 

var b = '中'                   	// 中文字符常量  
fmt.Println(b)                 	// unicode编码：20013
fmt.Println(reflect.TypeOf(b)) 	// 中文字符的类型：int32


var c = 65                     // 整型常量  
fmt.Println(c)                 // 65
fmt.Println(reflect.TypeOf(c)) // int

var y byte = '中'                // 编译错误，'中'字面量是 unicode 编码，占四个字节，无法被赋值给一个字节的byte类型。
// constant 20013 overflows byte

var b = "B"                     // 在go中，双引号括起来的常量是字符串，即使只包含一个字符。 
fmt.Println(string(b))          // B
fmt.Println(reflect.TypeOf(b))  // string



// rune类型相关示例
// 如果要表示unicode中的字符，就需要rune类型

var y rune = '中'
fmt.Println(y)                   // 20013 
fmt.Println(reflect.TypeOf(y))   // int32 



// 字符串类型
var d = "😀"                    // emoji字符串
fmt.Println(d)                  // 😀
fmt.Println(reflect.TypeOf(d))  // string
```





### 字符串

Go 的作者 Ken Thompson 是 UTF-8 的发明人（也是C，Unix，Plan9 等的创始人），因此在关于字符编码上，Go有着独到而周全的设计。

在 Go 中，字符串实际上是一个**只读的字节切片。**Go 语言中的字符串是原生数据类型，在内部实现使用 UTF-8 编码。

相比之下， C/C++语言中并不存在原生的字符串类型，通常使用字符数组来表示，并以字符指针来传递。

一个字符串包含任意多个字节，不论字符串是否包含 Unicode 文本、UTF-8 文本或任何其他预定义格式。

就字符串的内容而言，它完全等价于一个字节切片([]byte)。

**字符串中的一个字符，可能由多个字节构成。比如，"你好"这个字符串，由两个字符组成，但是由于UTF-8一个中文占3个字节，所以底层存储时由6个字节组成，`len("你好")` 为6。**

Go 将大部分字符串处理的函数放在了 `strings`,`bytes `这两个包里。

因为在字符串和整型间没有隐式类型转换，字符串和其他基本类型的转换的功能主要在标准库`strconv`中提供。

`unicode`相关功能在`unicode`包中提供。`encoding`包提供了一系列其他的编码支持。



- Go语言源代码总是采用`UTF-8`编码
- 字符串`string`可以包含任意字节序列，通常是`UTF-8`编码的。
- 字符串字面值，在不带有字节转义的情况下一定是`UTF-8`编码的。
- Go使用`rune`代表`Unicode`**码位**。一个**字符**可能由一个或多个码位组成（复合字符）
- Go string是建立在 **字节数组** 的基础上的，因此对string使用`[]`索引会得到字节`byte`而不是字符`rune`。
- Go语言的字符串不是正规化(`normalized`)的，因此同一个字符可能由不同的字节序列表示。使用`unicode/norm`解决此类问题。

- **字符串的值必须以双引号包裹，Go语言中单引号包裹的是字符类型**

```go
var str string  			//声明一个字符串类型的变量
str = "Hello world" 		//变量赋值
ch := str[0]                //取第一个字符

// 字符串的内容可以用类似于数组下标的方式获取，但与数组不同，字符串的内容不能在被初始化后被修改
str := "Hello world"
str[0] = 'X'  // 编译报错 cannot assign to str[0]


// 一个字符串，它使用十六进制串(\xNN格式)符号来定义一个字符串常量，其中包含一些特殊的字节值（字节的取值范围从十六进制值 00 到 FF）。
const sample = "\xbd\xb2\x3d\xbc\x20\xe2\x8c\x98"

// 由于上边我们的示例字符串 sample 中的某些字节不是有效的 ASCII，甚至不是有效的 UTF-8，所以直接打印字符串会产生奇怪的输出。产生这种乱码（其确切外观因环境而异）
fmt.Println(sample)

// 为了找出 sample 字符串底层到底是什么，我们需要把它拆开检查一下。有几种方法可以做到这一点。最明显的是循环其内容并单独提取字节

for i := 0; i < len(sample); i++ {
    fmt.Printf("%x ", sample[i])  // 输出为十六进制格式:bd b2 3d bc 20 e2 8c 98
}

// 正如前文所述，索引字符串访问的是单个字节，而不是单个字符

// 为凌乱的字符串生成可呈现输出的一种更简便的方法是使用`fmt.Printf`方法的`%x`（十六进制）格式，它只是将字符串的每两个连续字节转储为十六进制数字：
fmt.Printf("%x\n", sample)  // 使用`fmt.Printf`方法的`%x`（十六进制）格式，它只是将字符串的每两个连续字节转储为十六进制数字： bdb23dbc20e28c98
fmt.Printf("% x\n", sample) // 在`%和之间放置一个空格`x： bd b2 3d bc 20 e2 8c 98
 
fmt.Printf("%q\n", sample) // 使用 %q 动词将转义字符串中的任何不可打印的字节序列， "\xbd\xb2=\xbc ⌘"
// 一个 ASCII 等号和一个空格，最后出现了著名的瑞典“感兴趣的地方”符号。
// 该符号具有 Unicode 值 U+2318，由空格后面的字节编码为 UTF-8（十六进制值`20`）：e2 8c 98。


// 短声明字符串，并赋值
s := "Hello World"

// 单独的字母，汉字，符号表示一个字符
c1 = 'h'
c2 = '1'

// 字符串的内容可以用类似于数组下标的方式获取

var s2 = s[0]  // s2="H"



```



```go
package main

import "fmt"

func main() {
	const placeOfInterest = `⌘`

	fmt.Printf("plain string: ")
	fmt.Printf("%s", placeOfInterest)
	fmt.Printf("\n")

	fmt.Printf("quoted string: ")
	fmt.Printf("%+q", placeOfInterest)
	fmt.Printf("\n")

	fmt.Printf("hex bytes: ")
	for i := 0; i < len(placeOfInterest); i++ {
		fmt.Printf("%x ", placeOfInterest[i])
	}
	fmt.Printf("\n")
}


// 以三种不同的方式打印带有单个字符的字符串常量，一次作为纯字符串，一次作为仅 ASCII 引用的字符串，一次作为十六进制的单个字节。
// 为了避免混淆，我们创建了一个"原始字符串"，用反引号括起来，因此它只能包含文字文本（用双引号括起来的常规字符串可以包含转义符号，但反引号中不可以）

// plain string: ⌘
// quoted string: "\u2318"
// hex bytes: e2 8c 98 

// Unicode 字符值 U+2318，就是“感兴趣的地方”符号 ⌘，由字节表示是 e2 8c 98，而这些字节是十六进制值 2318 的 UTF-8 编码。


// Go 源代码是 UTF-8，因此字符串字面量的源代码是 UTF-8 编码格式。如果该字符串文字不包含原始字符串不能的转义序列，则构造的字符串将准确地保存引号之间的源文本。
// Unicode 标准使用术语"码点"来指代由单个值表示的项目。码点 U+2318，十六进制值为 2318，代表符号⌘。
```





多行字符串





#### 字符串转义符



|      |        |      |
| ---- | ------ | ---- |
| \n   | 换行符 |      |
|      |        |      |
|      |        |      |

#### 字符串常用函数

由于 Go 语言的字符串都以 UTF-8 格式保存，每个中文占用 3 个字节，因此使用 len() 获得两个中文文字对应的 6 个字节。

UTF-8 包提供的utf8.RuneCountInString() 函数用来统计 **Unicode** 字符数量。

```go
package main
 
import "fmt"
 
func main() {
	str1 := "hello world"
	fmt.Println(len(str1)) //11
 
	str2 := "你好"
	fmt.Println(len(str2)) //6
}



package main
 
import (
	"fmt"
	"unicode/utf8"
)
 
func main() {
	str1 := "hello world"
	fmt.Println(utf8.RuneCountInString(str1)) //11
 
	str2 := "你好"
	fmt.Println(utf8.RuneCountInString(str2)) //2
}

```





| 操作     | 方法                                    | 返回值                               |
| -------- | --------------------------------------- | ------------------------------------ |
| 长度     | len(s1)  utf8.RuneCountInString(s1)     | 返回字符串 s1 的长度                 |
| 拼接     | s1+s2 或者 fmt.Sprint( "%s%s", s1 , s2) | 返回新字符串                         |
| 分割     | strings.Split(s1 , "\\")                | 将 s1 字符串按 \ 分割                |
| 包含     | strings.Contains(s1, "Hello")           | 判断字符串中是否包含子串，返回布尔值 |
| 前缀判断 | fmt.HasPrefix(s1, "prefix")             | 判断字符串前缀中是否包含，返回布尔值 |
| 后缀判断 | strings.HasSuffix(s1,"suffix")          | 判断字符串后缀中是否包含，返回布尔值 |





### 浮点数

Go语言支持两种浮点数 float32 和 float64 。

float32大约可以提供小数点后 6 位的精度，作为对比，float64 可以提供小数点后 15 位的精度。通常情况应该优先选择 float64。

32位浮点数最大值是 `math.MaxFloat32`

64位浮点数最大值是 `math.MaxFloat64` ,  // 默认Go语言中的小数都是 float64 类型



### nil

golang中的`nil`，很多人都误以为与 Java、PHP 等编程语言中的 null 一样，但是实际上复杂很多。

`nil` 为预声明的标示符，定义在`builtin/builtin.go` 中。

```go
// nil is a predeclared identifier representing the zero value for a pointer, channel, func, interface, map, or slice type.
// Type must be a pointer, channel, func, interface, map, or slice type

// 简单说，nil就是 pointer, channel, func, interface, map, or slice 这些类型变量的零值
var nil Type 

// Type is here for the purposes of documentation only. It is a stand-in
// for any Go type, but represents the same type for any given function
// invocation.
type Type int
```

#### nil的零值

按照 Go 语言规范，任何类型在未初始化时都对应一个零值：

- 布尔类型是false，整型是0，字符串是""，
- **指针、函数、interface、slice、channel和map的零值都是 nil。**

Go 中的 nil 并不是一个关键字，



业务中一般将`nil`值表示为异常。nil 值的大小始终与其类型与`nil`值相同的`non-nil`值大小相同。因此, 表示不同零值的nil标识符可能具有不同的大小。



```go
f, err := os.Open(filename)
if err != nil {
	log.Println("Open file failed:", err)
	return
}
defer f.Close()


func Add(a ,b int) (ret int, err error)  {
   if a < 0 || b < 0 {
      err= errors.New("Should be non-negative numbers!")
      return
   }
   return a+b ,nil

}
```



### 复数

`complex64` 和 `complex128` 分别表示复数的实部和虚部



### 布尔类型

Go 语言中以 `bool` 声明布尔型数据，布尔型只有 true 和 false 两个值。

注意：

- 布尔类型变量的默认值是 false 
- Go 语言中不允许将整型强制转换为布尔型
- 布尔型无法参与数值运算，也无法与其他类型转换

if 和 for 语句的条件部分都是布尔类型的值，并且 `==` 和`<` 等比较操作也会产生布尔型的值。

**Go语言对于值之间的比较有非常严格的限制，只有两个相同类型的值才可以进行比较**











### 数组

数组是Go语言编程中最常用的数据结构之一，在 go 语言内部，数组就是一个**长度固定**的数据类型，用于存储一段具有相同的类型的元素的连续块。

go 语言中数组、字符串、切片在底层原始数据有着相同的内存结构，在上层，因为语法的限制而有着不同的行为表现。

首先，数组是一种值类型，虽然数组的元素可以修改的，但是数组本身的赋值和函数传参都是以整体复制的方式处理的。

所有的值类型变量在赋值和作为参数传递时都将产生一次复制动作。如果将数组作为函数的参数类型，则在函数调用时该参数将发生数据复制。

因此，在函数体中无法修改传入的数组的内容，因为函数内操作的只是所传入数组的一个副本。

**字符串底层数据也是对应的字节数组，但是字符串的只读属性禁止了在程序中对底层字节数组元素的修改。**



数组存储的元素类型可以是内置类型，如整型或者字符串，也可以是某种结构类型。

数组是一种非常有用的数据结构，因为其占用的内存是连续分配的。由于内存连续，CPU能把正在使用的数据缓存更久的时间。

而且内存连续很容易计算索引，可以快速迭代数组里的所有元素。数组的类型信息可以提供每次访问一个元素时需要在内存中移动的距离。

既然数组的每个元素类型相同，又是连续分配，就可以以固定速度索引数组中的任意数据，速度非常快。

```go
// 在Go语言中，数组长度在定义后就不可更改，在声明时长度可以为一个常量或者一个常量表达式（常量表达式是指在编译期即可计算结果的表达式）。
// 数组的长度是该数组类型的一个内置常量，可以用Go语言的内置函数 len() 来获取。

// 声明一个包含5个元素的整型数组，每个元素的默认值为对应类型的零值
// 数组一旦声明，数组长度不可变更
var array [5]int

// 声明并初始化，使用字面量来初始化数组
array1 := [5] int {10, 20, 30, 40, 50}

// 在数组文字中 ...代表数组长度，由后面初始化的字面值的数量计算出来
array2 := [...]int{10, 20, 30, 40, 50}

// 特定元素初始化，其余元素零值。
array3 := [5]int{1: 10, 2: 20}




// 数组中的元素是指针类型。5个指针（指向int类型变量的指针）
array4 := [5]*int { 0: new(int), 1: new(int)}
// 为索引为 0 和 1 的元素赋值
*array4[0] = 10
*array4[1] = 20


// 因为内存布局是连续的，所以数组是效率很高的数据结构。在访问数组里任意元素的时候，这种高效都是数组的优势。

// 元素访问，数组遍历
// 与C语言相同，数组下标从0开始， len(array)-1 则表示最后一个元素的下标

for i := 0; i < len(array);  i++ {
	fmt.Println("Element", i, "of array is", array[i])
}

// range遍历容器中的元素
// range遍历返回两个元素，一个是数组下标，一个是元素的值
for i, v := range array {
	fmt.Println("Array element[", i, "]=", v)
}


```



**数组的操作**

在 Go 语言里，数组是一个值。这意味着数组可以用在赋值操作中。变量名代表整个数组。因此，同样类型的数组可以赋值给另一个数组

```go
// 声明第一个包含 4 个元素的字符串数组
var array1 [4]string

// 声明并初始化第二个字符串数组
array2 := [5]string{"Red", "Blue", "Green", "Yellow", "Pink"}

// 只有当数组长度相同，且数组元素的类型相同时，才能赋值。数组长度不同，会溢出。go vet 阶段就会报错
// 数组也是一个数据类型，数组变量的类型包括数组长度和每个元素的类型。只有这两部分都相同的数组，才是类型相同的数组，才能互相赋值
// 将 array2 复制给 array1
array1 = array2


// 复制数值指针，只会复制指针值。而不会复制指针所指向的值。
// array1和array2这两组指针，都指向这些字符值的内存地址

// 声明第一个包含3个元素的指向字符串的指针数组1
var array1 [3]*string

// 声明第一个包含3个元素的指向字符串的指针数组2
array2 := [3]*string{new(string), new(string), new(string)}

// 为第二个指针数组中的指向的字符串变量赋值。
*array2[0] = "Red"
*array2[1] = "Blue"
*array2[2] = "Green"

// 将 array2 赋值给 array1
array1 = array2

// 赋值之后，两个数组指向同一组字符串，即它们的变量的内存地址是一样的。

fmt.Println(array1)  // [0xc000042230 0xc000042240 0xc000042250]
fmt.Println(array2)  // [0xc000042230 0xc000042240 0xc000042250]




// 多维数组

// 数组本身只有一个维度，不过可以组合多个数组创建多维数组。

// 声明一个二维整型数组，两个维度分别存储 4 个元素和 2 个元素
var array [4][2]int
// 使用数组字面量来声明并初始化一个二维整型数组
array := [4][2]int{{10, 11}, {20, 21}, {30, 31}, {40, 41}}
// 声明并初始化外层数组中索引为 1 个和 3 的元素
array := [4][2]int{1: {20, 21}, 3: {40, 41}}
// 声明并初始化外层数组和内层数组的单个元素
array := [4][2]int{1: {0: 20}, 3: {1: 41}}

// 为了访问单个元素，需要反复组合使用[]运算符
// 设置每个元素的整型值
array[0][0] = 10
```



**在函数间传递数组**

**在 go 中，数组是值类型，所有的值类型变量在赋值和作为参数传递时都将产生一次复制动作。如果将数组作为函数的参数类型，则在函数调用时该参数将发生数据复制。**

**因此，在函数体中无法修改传入的数组的内容，因为函数内操作的只是所传入数组的一个副本。**

```go
package main

import "fmt"

func modify( array [5]int )  {
	array[0] = 10   // 在函数中修改传入的数组参数的第一个元素
	fmt.Println("In modify function , array value is ", array)
	
}

func main()  {
	// 声明并初始化一个包含5个元素的整型数组
	array := [5]int {1,2,3,4,5}
	// 调用函数，实际并未修改原数组中的内容
	modify(array)
	// main函数打印数组，仍然是原数组的值
	fmt.Println("In main(), array values is", array)

}

// In modify function , array value is  [10 2 3 4 5]
// In main(), array values is [1 2 3 4 5]
```





```go
// 声明一个10W个整型的数组，需要8MB空间
var array [1e6]int

// 将数组传递给函数 foo
foo(array)

// 函数 foo 接受一个 100 万个整型值的数组，遍历并打印
func foo(array [1e6]int) {
    for i := 0; i < len(array); i++ {
         fmt.Print(array[i], "\t")
    }
}

// 像上面这种情况，每次函数 foo 被调用时，必须在栈上分配 8 MB 的内存，将数组中的值复制到内存中。


// 这次函数接收的参数是指针，是一个指向 100 万个整型值的数组的指针。
// 现在将数组的地址传入函数，只需要在栈上分配 8 节的内存给指针就可以
var array [1e6]int
foo(&array)
func foo(array *[1e6]int) {
	...
}
```









### 数组切片

在 Go 语言中，切片(slice)可能是使用最为频繁的数据结构之一，切片类型为处理同类型数据序列提供一个方便而高效的方式。

在 C 语言中，数组变量是指向第一个元素的指针，但是 Go 语言中并不是。

Go 语言中，数组变量属于值类型(value type)，因此当一个数组变量被赋值或者传递时，实际上会复制整个数组。





切片其实就是动态数组，它的长度并不固定，我们可以随意向切片中追加元素，而切片会在容量不足时自动扩容。

数组切片的数据结构可以抽象为包含三个变量的结构体：

- 一个指向原生底层数组的指针；
- 切片中的元素个数（即长度）；
- 切片允许增长的元素个数（即容量）；



```go
//  
type SliceHeader  struct {
  	array unsafe.Pointer
  	length int
  	capcity int
}
```



切片的底层是一个数组，切片的表层是一个包含三个变量的结构体，当我们将一个切片赋值给另一个切片时，本质上是对切片表层结构体的浅拷贝。

结构体中第一个变量是一个指针，指向底层的数组，另外两个变量分别是切片的长度和容量。

```go
// 创建切片基本上分为两种方法：基于数组创建切片，make函数直接创建切片




// 基于数组创建切片

// 定义一个数组
var myArray [10]int = [10]int{1, 2, 3, 4, 5, 6, 7, 8, 9, 10}

// 基于数组创建一个切片数组：前五个元素
var mySlice []int = myArray[:5]

// 所有元素 mySlice = myArray[:] 
// 前n个元素 mySlice = myArray[:5]
// 从第n个元素开始，mySlice = myArray[5:]

// mySlice = myArray[x:y:z]
// 从第x个元素开始，第z个元素止，z-x是容量，如果z=y，可以省略


// 基于内置的make函数直接创建切片

// make(元素类型,切片长度,切片容量)
mySlice2 := make([]int, 5, 10)

// make(元素类型,切片长度) ，当长度和容量相同时，可以省略容量
mySlice1 := make([]int, 5)


//  cap(slice) 返回切片的容量, len(slice) 返回切片的长度


// 容量是当前切片已经预分配的内存能够容纳的元素个数，如果往切片中不断地增加新的元素。
// 如果超过了当前切片的容量，就需要分配新的内存，并将当前切片所有的元素拷贝到新的内存块上。
// 因此为了减少内存的拷贝次数，容量在比较小的时候，一般是以 2 的倍数扩大的，例如 2 4 8 16 …，当达到 2048 时，会采取新的策略，避免申请内存过大，导致浪费。

// 切片字面量
// 声明字符串切片，其长度和容量都是5个元素，这跟数组的声明很像，只是不需要指定[]运算符里的值。长度和容量由初始化的元素个数决定。
slice := []string{"Red", "Blue", "Green", "Yellow", "Pink"}

// 声明整型切片，其长度和容量都是3个元素
slice2 := []int{10, 20, 30}

// 使用索引声明切片
// 使用空字符串初始化第100个元素(这个切片的长度和容量是100)
slice := []string{99: ""}





// nil切片
// 程序可能需要声明一个值为 nil 的切片，只要声明时不做任何初始化就会创建空切片
// 在go中，nil切片是很常见的创建切片的方法，nil切片用于很多标准库和内置函数。

// 切片中的元素是指针，指针的零值是nil，所以是
var s1 = make([]*int, 10)
fmt.Println(s1)  // [<nil> <nil> <nil> <nil> <nil> <nil> <nil> <nil> <nil> <nil>]

// 切片中的元素都是int，int类型的零值都是0
var s = make([]int, 10)
fmt.Print(s)  // [0 0 0 0 0 0 0 0 0 0]


// 空切片
// 整型空切片
var slice []int
fmt.Print(slice) // []
fmt.Print(reflect.TypeOf(slice))  //切片的数据类型 []int 

// 使用 make 创建空的整型切片变量
slice := make([]int, 0)

// 等价于上面，使用字面量创建空的整型切片
slice := []int{}


// 使用字面量创建整型切片，其容量和长度都是 5 个元素
slice := []int{10, 20, 30, 40, 50}

// 使用切片创建切片
// 创建一个切片，其长度为 2 个元素，容量为 4 个元素
newSlice := slice[1:3]


// 对底层数组容量是 k 的切片 slice[i:j]来说
// 长度: j - i     len(s) len函数返回切片长度
// 容量: k - i	 cap(s)	cap函数返回切片容量 


// 切片是引用类型
// 对切片中的元素的修改，也会对其底层数组的元素修改

slice := []int{10, 20, 30, 40, 50} // 声明一个原始切片  [10 20 30 40 50]
fmt.Println(slice)                 // 打印原始切片     [10 20 30 40 50]
newSlice1 := slice[1:3]            // 新切片1 [20 30]
fmt.Println(newSlice1)             // 打印新切片1  [20 30]
newSlice1[0] = 90                  // 修改新切片1的第0个元素  20-> 90	, 也会对原始切片的元素修改   [10 20 30 40 50]
newSlice2 := slice                 // 将原始切片赋值给一个新切片2
fmt.Println(newSlice1)             // 新切片1 [90 30]   
fmt.Println(newSlice2)			   // 新切片2      [10 90 30 40 50]      	


// 切片的 append 
// 与数组不同，可动态增减元素是数组切片比数组更为强大的功能

// appen()函数是builtin.go中定义的一个函数，它的定义如下：func append(slice []Type, elems ...Type) []Type
// append(被操作的切片,要被增加的元素... ) ，按照 append 语义，第二个参数其实是一个不定长参数。可以根据需求添加n个元素
slice := []int{10, 20, 30, 40, 50}  //  [10 20 30 40 50]
newSlice := slice[1:3] // [20 30]
newSlice = append(newSlice, 60)  // [20 30 60]
// 由于和原始的 slice 共享同一个底层数组，slice 中索引为 3 的元素的值也被改动了。[10 20 60 40 50]

// 切片添加元素时，第二个元素也可以是切片，要注意加上 ... （相当于把第二个切片打散传入）
mySlice = append(mySlice, mySlice2...)


// 如果切片的底层数组没有足够的可用容量，append 函数会创建一个新的底层数组，将被引用的现有的值复制到新数组里
// 当这个 append 操作完成后，newSlice 拥有一个全新的底层数组，这个数组的容量是原来的两倍
// 函数 append 会智能地处理底层数组的容量增长。在切片的容量小于 1000 个元素时，总是会成倍地增加容量
// 一旦元素个数超过 1000，容量的增长因子会设为 1.25，也就是会每次增加 25% 的容量


// 为了保持原有切片的底层数组不被改变，可以创建一个长度和容量相同的切片，这时候再append，就可以强制让新切片的第一个 append 操作创建新的底层数组，与原有的底层数组分离。
// 新切片与原有的底层数组分离后，可以安全地进行后续修改
source := []string{"Apple", "Orange", "Plum", "Banana", "Grape"}  //字符串切片
slice := source[2:3:3]     //对第三个元素切片，长度和容量都是1 ，[Plum]
slice = append(slice, "Kiwi")   // 对新切片追加字符串
// 由于新切片长度和容量都是1，append的时候，会创建一个新的底层数组，这个数组包括 2 个元素，并将水果 Plum 复制进来，再追加新水果 Kiwi，并返回一个引用了这个底层数组的新切片
// 这样就不会对原始切片造成修改




// 切片内容复制




// 切片的迭代

// 切片的迭代，返回两个值，第一个值是当前迭代到的索引位置，第二个值是该位置对应元素值的一份副本。

slice := []int{10, 20, 30, 40}

for index, value := range slice {
	fmt.Printf("\n")
	// 迭代每个元素
	// 索引位置，值，值地址，元素地址
	// 因为迭代返回的变量是一个迭代过程中根据切片依次赋值的新变量，所以 value 的地址总是相同的。
    // 要想获取每个元素的地址，可以使用切片变量和索引值。(&slice[index])
	fmt.Printf("index : %d , Value : %d , Value-Addr : %X  , ElemAddr: %X\n ", index, value, &value, &slice[index])
}


slice := []string {"apple", "green" , "yellow" , "pink"}

// 在迭代中只获取元素值
for _ , value := range slice{
	fmt.Printf("Value is %s\n",value)
}

// 从第 n 个元素开始迭代
for index := 2; index < len(slice) ; index++ {
	fmt.Printf("The Index %d of the Value is %s\n",index ,slice[index])
}



// 多维切片

// 和数组一样，go也支持多维切片，组合多个切片为一个切片。
// 整型切片的切片 
//  外层的切片包括两个元素，每个元素都是一个切片。第一个元素中的切片使用单个整数 10 来初始化，第二个元素中的切片包括两个整数，即 100 和 200。
slice := [][]int{{10}, {100, 200}}


```



### map

在C++/Java中， map 一般都以库的方式提供，比如在C++中是STL的 std::map<> ，在C#中是 Dictionary<> ，在Java中是 Hashmap<> ，在这些语言中，如果要使用 map ，事先要引用相应的库。

在Go中，使用 map 不需要引入任何库，并且用起来也更加方便。

**map 是一系列无序的键值对集合。map 是一个集合，可以用类似数组和切片的方式来迭代map中的元素。**

**但 map 是无序的集合，意味着没有办法预测键值对被返回的顺序。即便使用同样的顺序保存键值对，每次迭代映射的时候顺序也可能不一样。**

**无序的原因是 map 的实现使用了散列表这种数据结构（又叫哈希表）。**



#### map 内部实现

在向 map 中存储元素的时候，会将每个 key 经过 hash 运算，根据运算得到的 hash 值选择合适的 hash bucket(hash桶)，让后将各个 key/value 存放到选定的hash bucket 中。如果一来，整个map将根据bucket被细分成很多类别，每个key可能会交叉地存放到不同的bucket中。



在 /usr/local/go/src/runtime/hashmap.go 中可以查看它的实现细节。



> referer 
>
> http://yangxikun.github.io/golang/2019/10/07/golang-map.html
>
> https://draveness.me/golang/docs/part2-foundation/ch03-datastructure/golang-hashmap/



```go
// map的语法 map[key_type] value_type
// key_type：键类型可以是任意类型，这个值的类型可以是内置的类型，也可以是结构类型，只要这个值可以使用==运算符做比较。
// 切片、函数以及包含切片的结构类型这些类型由于具有引用语义，不能作为映射的键，使用这些类型会造成编译错误
// value_type: 值类型可以是任意类型，map[int] []string{} // 使用字符串切片做为map的值类型


////////////////////////////////////////////// map声明 //////////////////////////////////////////////////////////

// nilmap: 未被初始化的map都称为 nil map 。无法进行赋值，因为没有申请底层数据结构的内存空间
// 声明一个map类型的变量（键string,值string）
var myMap map[string]  string 


// 空map: 不做任何赋值的map，已经申请了底层数据结构的内存空间
my_map := map[string]string{}

// nil map和empty map的关系，就像nil slice和empty slice一样，两者都是空对象，未存储任何数据。
// 但前者不指向底层数据结构，后者指向底层数据结构，只不过指向的底层对象是空对象。


package main

func main() {
	var nil_map map[string]string
	println(nil_map)

	emp_map := map[string]string{}
	println(emp_map)
}

// 输出如下：显然，map是指针
0x0
0xc000042610



// 使用make函数声明一个map(key的类型是 string，value的类型是 int)
dict := make(map[string]int)
// 声明一个map(key的类型是 string，value的类型是 string)
dict := make(map[string]string)
// 声明一个map(key的类型是 string，value的类型是字符串切片)
dict := make(map[string] []string)



// 使用map字面量声明并初始化map，map的长度由键值对的数量决定
dict := map[string]string{
	"Red":    "#da1337",
	"Orange": "#e95a22",
}


// 声明一个存储能力为100的map，在尽可能的情况下，使用 make() 初始化的时候提供容量信息
// make函数其实是构造了字面量
myMap = make(map[string] string, 100)


// 创建一个空map
colors := map[string]string{}
// 为map添加元素
colors["Red"] = "#da1337"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////



// 查找map

// 查找map中是否存在某个键，这是map的最基本的操作。

// 在go中，map["key"]返回两个值：value表示这个key对应的value，exits(布尔类型)表示key是否存在

// 在go中，通过键来索引映射时，即便这个键不存在，value也总会返回一个值。在这种情况下，返回的是该值对应的类型的零值。

// 判断map中是否能成功取到特定的键，不需要检查取到的值是否为 nil ，只需看第二个返回值 ok

value , exists := colors["Blue"]
// 这个键存在吗？
if exists {
	fmt.Println(value)
    // balabala
}


// 迭代map

// 与切片和数组一样，只不过 range 返回的不是索引和值，而是键值对。

colors := map[string]string{
	"AliceBlue": "#f0f8ff",
	"Coral": "#ff7F50",
	"DarkGray": "#a9a9a9",
	"ForestGreen": "#228b22",
}
// 如果只需要key或value。就可以用下划线来声明变量
for key, value := range colors {
		fmt.Printf("Key: %s Value: %s\n", key, value)
}


// 删除元素

// 从colors这个map中删除键为 Coral 的键值对
delete(colors, "Coral")


// 元素个数
// 统计map中的元素个数
len(colors)
```





## 函数

函数构成代码执行的逻辑结构，在 Go 语言中，函数的基本组成为：关键字 func 、函数名、参数列表、返回值、函数体和返回语句。

main 函数既没有参数，也没有返回类型（与 C 家族中的其它语言恰好相反）。

在程序开始执行并完成初始化后，第一个调用（程序的入口点）的函数是 `main.main()`（如：C 语言），该函数一旦返回就表示程序已成功执行并立即退出。

函数里的代码（函数体）使用大括号 `{}` 括起来。

左大括号 `{` 必须与方法的声明放在同一行，这是编译器的强制规定，否则你在使用 gofmt 时就会出现错误提示：

```go
`build-error: syntax error: unexpected semicolon or newline before {`
```

（这是因为编译器会产生 `func main() ;` 这样的结果，很明显这错误的）

**Go 语言虽然看起来不使用分号作为语句的结束，但实际上这一过程是由编译器自动完成，因此才会引发像上面这样的错误**

右大括号 `}` 需要被放在紧接着函数体的下一行。如果你的函数非常简短，你也可以将它们放在同一行：

```go
func Sum(a, b int) int { return a + b }
```



### 函数结构

```go
// 

func  函数名（）（参数列表) (返回值列表) {

	函数体
}


func functionName(parameter_list) (return_value_list) {
   …
}

// 函数入参：parameter_list 的形式为 (param1 type1, param2 type2, …)

// 
// 返回参数：return_value_list 的形式为 (ret1 type1, ret2 type2, …)

// 只有当某个函数需要被外部包调用的时候才使用大写字母开头，并遵循 Pascal 命名法；
// 否则就遵循骆驼命名法，即第一个单词的首字母小写，其余单词的首字母大写。



func Add(a int, b int) (ret int, err error) {
	if a < 0 || b < 0 { 
		err= errors.New("Should be non-negative numbers!")
	return
	}
	return a + b, nil   // 支持多重返回
}

// 当有多重返回的时候，在返回参数列表中，可以为返回参数命名，让代码更加清洗
// Go语言并不需要强制命名返回值，但是命名后的返回值可以让代码更清晰，可读性更强，


// 调用多重返回函数时，可以忽略某个返回值
n, _ := f.Read(buf)


// 如果参数列表，返回值列表中的多个参数的数据类型相同，可以合并
func Add(a ,b int) (ret , num int, err error){
    
}



// 不定参数，函数传入的参数数量是不确定的
// ... type 这种格式只能存在于函数参数中，并且是最后一个参数
// 类型 ...type 本质上是一个数组切片
func myfunc(args ...int){
    for _, arg := range args {
		fmt.Println(arg)
	}
}


// 任意类型的不定参数，指定类型为 interface{}
// 下面是 Go 标准库中的fmt.Printf()的函数原型
// 用 interface{} 传递任意类型数据是Go语言的?例用法
func Printf(format string, args ...interface{}) {
	// ...
}
```



### 匿名函数

匿名函数由一个不带函数名的函数声明和函数体组成，可以将函数赋值给变量

```go
package main

import (
	"fmt"
)

func main() {
    // 声明一个函数，并将函数赋值给一个变量f
	f := func() {
		fmt.Println("hello world")
	}
	f()                   //hello world
    // 打印变量的数据类型
	fmt.Printf("%T\n", f) //打印 func()
}



// output:
// hello world
// func() 
```



```go
package main

import (
   "fmt"
)

func main() {
    // 声明匿名函数并赋值给一个变量，用变量名的方式去调用 
   f:=func(args string){
      fmt.Println(args)
   }
   f("hello world")//hello world
   
   // 直接将函数声明体括起来做为函数名，后跟括号来调用函数
   (func(args string){
        fmt.Println(args)
    })("hello world")//hello world
    
    // 不用括号，直接调用
    func(args string) {
        fmt.Println(args)
    }("hello world") //hello world

```

```go
package main

import (
    "fmt"
)

func main() {
	a := 1
	b := 2
	c := 3
	
    // 函数返回值赋给两个变量
    r, d := plus(a, b, c)
    fmt.Printf("%T\n", d)
    // 调用匿名函数
    d()
	fmt.Println(r)

}

// 这个函数返回两个变量：第一个是int类型的，第二个是匿名函数
func plus(x, y , z int) (name int, fun func()) {
	sum1 := x + y + z
	f := func() {
		fmt.Println("hello world")
	}
    return sum1, f

}


//output

hello world
6

```







```go
package main

import (
	"fmt"
)

func main() {
   f1,f2:=F(1,2)
   fmt.Println(f1(4))//6
   fmt.Println(f2()) //6
}
// 声明一个函数，参数是两个int，返回值是两个函数（函数内部声明两个匿名函数并赋给变量）
func F(x, y int)(func(int)int,func()int) {
   
   // 调用 f1 的时候可以传 int 类型的参数，返回int类型的数据 
   f1 := func(z int) int {
      return (x + y) * z / 2
   }

   //调用 f2 的时候没有入参，返回int类型的数据  
   f2 := func() int {
      return 2 * (x + y)
   }
   return f1,f2
}
```



### 闭包

闭包：说白了就是函数的嵌套，内层的函数可以使用外层函数的所有变量，即使外层函数已经执行完毕。

```go
package main

import "fmt"

func main() {

	// a是一个函数类型的变量，这里面也存了一个字符串变量x，每次调用a的时候，都会在 x 后面加 hello
	a := Fun()
	b := a(" hello")
	c := a(" hello")
	d := a(" hello")
	fmt.Println(b) //world hello
	fmt.Println(c) //world hello hello
	fmt.Println(d) //world hello hello hello

}

// 声明一个名为 Fun 的函数, 这个函数有一个返回值，数据类型是函数类型，这个函数类型的参数和返回值的类型都是string
func Fun() func(string) string {
	x := "world"
	return func(args string) string {
		x += args
		return x
	}
}





```



```go
package main

import "fmt"

func main() {
	a := 1
	b := 2
	c := 3

	r, h := plus(a, b, c)
	h()
	//fmt.Printf(plus(a, b, c))
	fmt.Println(r)
	h()

}

func plus(x, y int, z int) (name int, fun func()) {
	sum1 := x + y + z
	f := func() {
		fmt.Println("hello world")
	}
	f()
	return sum1, f

}

```







## 面向对象

在 go 语言中，你可以给任意类型添加方法（包括内置类型，但不包括指针类型）





```go



// 使用

func main() {
    // 声明
	var a Integer = 1
    // 调用其方法
	if a.Less(2) {
	fmt.Println(a, "Less 2")
	}
}


// 声明一个基于int的类型Integer。有点像java中的extend关键字（类继承）
type Integer int

// 面向过程

// 声明一个函数Integer_Less，两个integer入参，一个bool返回参数
func Integer_Less(a , b Integer) bool {
	return a < b
}

// 面向过程的函数调用
Integer_Less(a , 2)



// 面向对象

// 声明一个函数 Less，可以作用于Integer类型的变量上。有点像面对对象中，给某个类声明一个方法 
func (a Integer) Less(b Integer) bool { 
 	return a < b   
}

// 面对对象的函数调用
a.Less(2)


// 基于指针的传递（Integer类型的指针变量a）
func (a* Integer) Add_pointer (b Integer) {
    *a += b
}

// 基于值的传递。
func (a Integer) Add_value (b Integer) {
    a += b
}


func main() {
    var a Integer = 1
    var b Integer = 1
    a.Add_pointer(2)
    b.Add_value(2)
    fmt.Println("a =", a)
    fmt.Println("b =", b)
}

// a=3
// b=1
```





### 方法/函数

**方法能给用户定义的类型添加新的行为。方法实际上也是函数，只是在声明时，在关键字 func 和方法名之间增加了一个参数。**



**关键字 func 和函数名之间的参数被称作接收者，将函数与接收者的类型绑在一起。如果一个函数有接收者，这个函数就被称为方法。**

```go
// 声明一个用户自定义类型：user结构体
type user struct {
	name       string
	email      string
}


// 声明值接收者声明的方法
func (u user) notify() {
	fmt.Printf("Sending User Email To %s<%s>\n", u.name, u.email)
}

// user类型的值可以调用方法
// 这个语法与调用一个包里的函数看起来很类似,但在这个例子里，bill 不是包名，而是变量名，
// 这段程序在调用 notify 方法时，使用 bill 的值作为接收者进行调用,方法 notify 会接收到 bill 的值的一个副本
bill := user{"Bill", "bill@email.com"}
bill.notify()

// 也可以用指向 user 类型值的指针来调用这个值接收者方法
// 可以认为 go 指向了 (*lisa).notify() 这种方式的调用，notify 操作的是一个副本，只不过这次操作的是从 lisa 指针指向的值的副本。
lisa := &user{"Lisa", "lisa@email.com"}
lisa.notify()





// 声明指针接收者方法
func (u *user) changeEmail(email string) {
	u.email = email
}


// 这个接收者的类型是指向 user 类型值的指针，而不是 user 类型的值,调用这个方法时，这个方法会共享调用方法时接收者所指向的值


```







#### 值接收者



#### 指针接收者







## 错误处理



go 引入了一个关于错误处理的标准模式。



Go语言引入了两个内置函数 panic() 和 recover() 以报告和处理运行时错误和程序中的错误场景：

- func panic(interface{})
- func recover() interface{}



当在一个函数执行过程中调用 panic() 函数时，正常的函数执行流程将立即终止，但函数中之前使用 defer 关键字声明的延迟执行的语句将正常展开执行，之后该函数将返回到调用函数，并导致逐层向上执行 panic 流程，直至所属的goroutine中所有正在执行的函数被终止。

**错误信息将被报告，包括在调用 panic() 函数时传入的参数，这个过程称为错误处理流程。**



从 panic() 函数的参数类型 interface{} ，可以很容易该资源接收任意类型的数据。比如：整型、字符串、对象。







## defer 关键字

> refer 
>
> https://deepzz.com/post/how-to-use-defer-in-golang.html
>
> https://www.cyub.vip/2020/05/30/%E6%B7%B1%E5%85%A5%E4%BA%86%E8%A7%A3golang%E4%B8%AD%E7%9A%84defer%E5%85%B3%E9%94%AE%E5%AD%97/





golang 中的 defer 关键字用来声明一个延迟函数，该函数会放在一个列表中，在 defer 语句的外层函数返回之前系统会执行该延迟函数。



当程序执行一个函数时候，会将函数的上下文（输入参数，返回值，输出参数等信息）作为栈帧放在程序内存的栈中，当函数执行完成之后，设置返回值并返回，此时栈帧退出栈，函数才真正完成执行。



```go
func main() {
    defer fmt.Println("A")
    fmt.Println("B")
}
// 依次输出B A


func main() {
    fmt.Println("A")
    defer fmt.Println("B")
    fmt.Println("C")
}
// 依次输出A C B

// defer语句一定要在函数return语句之前，这样才能生效。




```







## 结构体

Go 语言是一种静态类型的编程语言。这意味着，编译器需要在编译时知晓程序里每个变量值的类型。

**值的类型**给编译器提供两部分信息：第一部分，需要分配多少内存给这个值（即值的规模）；第二部分，这段内存表示什么。

对于许多内置类型的情况来说，规模和表示是类型名的一部分。

- int64 类型的值需要 8 字节（64 位），表示一个整数值；
- float32 类型的值需要 4 字节（32 位），表示一个 IEEE-754 定义的二进制浮点数；
- bool 类型的值需要 1 字节（8 位），表示布尔值 true和 false。



有些类型的内部表示与编译代码的机器的体系结构有关。例如，根据编译所在的机器的体系结构，一个 int 值的大小可能是 8 字节（64 位），也可能是 4 字节（32 位）。

还有一些与体系结构相关的类型，如 Go 语言里的所有引用类型。好在创建和使用这些类型的值的时候，不需要了解这些与体系结构相关的信息。

但是，如果编译器不知道这些信息，就无法阻止用户做一些导致程序受损甚至机器故障的事情。



Go 语言允许用户定义类型，当用户声明一个新类型时，这个声明就给编译器提供了一个框架，告知必要的内存大小和表示信息。



```go
// user类型： 在程序里定义一个结构体，结构体类型通过组合一系列固定且唯一的字段来声明
// 结构体里每个字段都会用一个已知类型来声明。这个已知类型可以是内置类型，也可以是其他用户定义的类型
type user struct {
	name       string
	email      string
	ext        int
	privileged bool
}

// 声明user类型的变量，其属性都是零值
var bill user

// 任何时候，创建一个变量并初始化为其零值，习惯是使用关键字 var。这种用法是为了更明确地表示一个变量被设置为零值
// 如果变量被初始化为某个非零值,就配合结构字面量和短变量声明操作符来创建变量

// 声明user类型的变量，结合字面量和短声明表示
Lisa := User{
	name:       "Lisa",
	email:      "lisa@email.com",
	ext:        123,
	privileged: true,
}

// 声明 user 类型的变量，这种形式，值的顺序必须和类型声明中的字段顺序一致
lisa := user{"Lisa", "lisa@email.com", 123, true}



// 定义一个新的结构体类型，这个结构体里面包含其他的自定义类型
type admin struct {
    person  user
    level   string
}


// 先声明一个user类型的结构体字面量赋给person字段，再组合person和level一起组合成admin的结构体字面量
tom :=  admin{
    person := user{
       	name:       "Lisa",
		email:      "lisa@email.com",
		ext:        123,
		privileged: true, 
    },
    level: "superuser"
}




```













# go 运算符

go 语言中的位运算都是在二进制上进行的。所以在位运算之前要先将数转换成二进制。

go 中有一些特殊的运算符：

```shell
&      位运算 AND     
|      位运算 OR   
^      位运算 XOR
&^     位清空 (AND NOT)
<<     左移
>>     右移
```



按位与  &                两个数都为1时，结果才为1，否则为0



按位或 |                   两个数都为0时，结果才为0，否则为1



异或运算  ^              两个数相同则为0，不同则为1 



^ 如果做为二元运算符的时候，是异或运算，









# 流程控制





## 循环语句for



Golang 中的for循环支持三种循环方式，包括类似 while 的语法。



```go
for init; condition; post { }
for condition { }
for { }

/**
init： 初始化语句，一般为赋值表达式，给控制变量赋初值；
condition： 关系表达式或逻辑表达式，循环控制条件；
post： 一般为赋值表达式，给控制变量增量或减量。
for语句执行过程如下：
①先对表达式 init 赋初值；
②判别赋值表达式 init 是否满足给定 condition 条件，若其值为真，满足循环条件，则执行循环体内语句，然后执行 post，进入第二次循环，再判别 condition；
否则判断 condition 的值为假，不满足条件，就终止for循环，执行循环体外语句。
**/



for x := 1; x <= 3; x++ {
    fmt.Println(x) ;   // 1,2,3 
}

// 初始化变量移到前面。post语句放到循环体中
x := 1
for x<3 {
    fmt.Println(x) ;   // 1,2,3 
    x++
}

fmt.Println() 
```





























