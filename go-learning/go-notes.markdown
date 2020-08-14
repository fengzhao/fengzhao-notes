##  包和文件

golang 以包来组织程序，包类似于其他语言中的库，一个包由一个或多个 .go 为文件名后缀的源代码文件组成。

放在一个文件夹中，文件夹描述了包名的作用。**一般用文件夹名做为包名**

每一个 .go 文件都属于且仅属于一个包。

即  \go\src\net 是一个文件夹，是一个包，这个包名叫 net  ，net 目录里面 go 文件都声明 package net 

每一个源文件中第一行使用 package 来声明这个文件所属的包。后面跟上 import 关键字来导入其他包。

例如 ：gopl.io/ch1/helloworld 这个包对应的目录路径是 $GOPATH/src/gopl.io/ch1/helloworld

每个包提供了独立的 **命名空间**。包内的标识符需要通过大写字母开头来表示可以被外部包引用，

引用外部包中的变量或函数时，一般通过 **package.Identifier** 这样的格式引用

包可以看做一个类库或者命名空间，当在一个 .go 文件里导入一个包后，就可以使用该包里面的常量、变量、类型、函数名、结构字段等等。

### Main包

在 go 中，命名为 main 的包具有特殊含义，Go 语言的编译程序会试图把这种名字的包编译为二进制可执行文件。

**所有用 Go 语言编译的可执行程序都必须有一个名叫 main 的包。**

当编译器发现 main 包，也一定会发现 main() 函数，否则不会创建可执行文件。

main 函数是程序入口，

程序编译时，会使用声明 main 包的代码所在的目录的目录名作为二进制可执行文件的文件名。

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

每个语言都有导包机制，golang 也不例外，在 go 源文件中，使用 import 来导入外部包。

如果你的包引入了三种类型的包, 标准库包, 程序内部包, 第三方包, 建议采用如下方式进行组织你的包:

- 标准库包（有超过一百多个包，使用 go list std 列出所有标准库包）
- 程序内部包 从 gopath 环境变量的路径中查找
- 第三方包

go 编译器在导包的时候，按照上述顺序导入，一旦找到满足要求的，就停止查找。

```go
//导包方法
//导一个包，标准库中的包
import "fmt"


//导多个包
import (
   "fmt"
   "os"
)


// 导当前工程下的自定义包
import "pk1/pk2"



// 导包规范：有顺序的引入包, 不同的类型采用空格分离:
	// 第一种是标准库,
	// 第二种是项目包
	// 第三种是第三方包. 远程导入，导入路径是一个远程URL，使用 go get 下载到 gopath/src/github.com/astaxie/beego 这个路径
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

// 导包避免冲突，当两个包有一样的名字时，可以取一个别名来处理冲突问题
// 引用包内变量和函数时，可以使用别名引用
import (
    "math/rand"
    crand "crypto/rand"
)
```

#### 空导入

在 golang 中，**导入一个包而不用和函数内声明变量但是并不使用一样**，都会编译错误。

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

// 使用 _ 的方式来导入未被引用到的包，也可以编译通过，表示暂时不会用到这个包，后续可能会用到
import (
    "fmt"
    _ "math/rand"
    _ "crypto/rand"
)
func main() {
    fmt.println("Go is great!")
}


// 当你导入了一个不在代码里使用的包时，Go 编译器会编译失败，并输出一个错误。Go 开发
// 团队认为，这个特性可以防止导入了未被使用的包，避免代码变得臃肿。虽然这个特性会让人觉
// 得很烦，但 Go 开发团队仍然花了很大的力气说服自己，决定加入这个特性，用来避免其他编程
// 语言里常常遇到的一些问题，如得到一个塞满未使用库的超大可执行文件。很多语言在这种情况
// 会使用警告做提示，而 Go 开发团队认为，与其让编译器告警，不如直接失败更有意义。每个编
// 译过大型 C 程序的人都知道，在浩如烟海的编译器警告里找到一条有用的信息是多么困难的一件
// 事。这种情况下编译失败会更加明确。
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

Go 中的包模型采用了显式依赖关系的机制来达到快速编译的目的



如果包中含有多个 .go 源文件，它们将按照发给编译器的顺序进行初始化，Go语言的构建工具首先会将 .go 文件根据文件名排序，然后依次调用编译器编译

对于在包级别声明的变量，如果有初始化表达式则用表达式进行初始化，还有一些没有初始化表达式的，例如某些表格数据初始化并不是一个简单的赋值过程。

在这种情况下，我们可以用一个特殊的 `init` 初始化函数来简化初始化工作。**每个文件都可以包含多个 `init` 初始化函数**:

```go
func init() { /* ... */ }
```

**这样的 `init` 初始化函数除了不能被直接调用或引用外，其他行为和普通函数类似。**

在每个文件中的 `init` 初始化函数，在程序开始执行时按照它们声明的顺序被自动调用。

init函数通常用来做初始化变量、设置包或者其他需要在程序执行前的引导工作。

比如上面我们讲的需要使用`_`空标志符来导入一个包的目的，就是想执行这个包里的init函数。

每个包可以包含任意多个 init 函数，这些函数都会在程序执行开始的时候被调用。

所有被编译器发现的 init 函数都会安排在 main 函数之前执行。init 函数用在设置包、初始化变量或者其他要在程序运行前优先完成的引导工作。

每个包在解决依赖的前提下，以导入声明的顺序初始化，每个包只会被初始化一次。

因此，如果一个p包导入了q包，那么在p包初始化的时候可以认为q包必然已经初始化过了。

初始化工作是自下而上进行的，main包最后被初始化。以这种方式，可以确保在main函数执行之前，所有依赖的包都已经完成初始化工作了。

```go
// 我们以数据库的驱动为例，Go语言为了统一关于数据库的访问，使用databases/sql抽象了一层数据库的操作
// 可以满足我们操作MySQL、PostgreSQL等数据库，这样不管我们使用这些数据库的哪个驱动，编码操作都是一样的，
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



## 名称

golang 中 **函数、变量、常量、类型、语句、包名** 都遵循如下规则：

- 包名小写

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

golang是一个强类型语言，变量在声明的时候，必须要确定类型。

使用 var 关键字来声明变量，变量声明的通用格式如下：

```
var name type = expression 
```

类型和表达可以省略一部分，但是不能都省略：

- 如果省略类型，则在声明的时候即显式赋值，变量类型由赋值表达式决定；

- 如果省略表达式，变量类型由type类型决定，其初始值是该类型的**零值**。

  - 数字类型的零值是0。
  - 接口和引用类型（slice，指针，map，通道，函数）的零值是 nil 
  - 对于结构体或数组这样的复合类型，零值是其所有元素或成员的零值。

**所以 golang 中不存在未初始化的变量**。零值机制保证了所有的变量都是良好定义的。

声明变量列表：

```go
// 声明三个int类型的变量 i,j,k
var i,j,k int   
// 声明三个不同类型的变量
var b,f,s = true , 2.3 , 'four' 
```

**包级别的变量在 main 开始之前就进行了声明和赋值。**

### 短变量(短声明)

在函数中，可以使用短变量的形式来声明和初始化局部变量。使用如下格式：

```go
name := expression
```

**短变量主要用于局部变量声明。（函数外不允许使用短声明）**

多变量声明也可以用短声明的方式进行声明：

```go
i,j := 0,1
f , err = os.Open(name)

// 多变量声明中也可以混带赋值,对于s来说，这是声明并赋值，对于i来讲，因为已声明过了，这就是赋值操作。
s , i = 1,0

// 短变量最少声明一个变量，因为f和err都已声明过，所以这样的代码无法编译通过，编译错误：没有新的变量
f , err = os.Open(newname)
```

`:=` 是一个声明动作，`=` 是一个赋值动作。多变量声明不能与**多重赋值**搞混：

```go
// 多重赋值，交换i和j的值
i , j = j , i
```



### 变量的内存大小





### 指针

指针，是一个变量的地址，使用指针，可以在不知道变量名的情况下，直接读取或操作变量值。

声明一个整形变量 `var x int`，表达式 &(x) 获取指向x这个整型变量的指针。这个表达式的类型就是整型指针（*int）。

如果这个整形指针叫做 p , 那么说 p 指向 x , 或 p 包含 x 的地址，p 指向的变量写作 *p  。

```go
//  /go-demo/pointer.go

package main

import (
    "fmt"
    "reflect"
)

func main() {
    var a int32 = 1
    var b int = 2
    fmt.Println(a,b)
    var c = &b
    var d = &c
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
// 创建一个指针c，存放变量b的地址
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

另一种创建变量的方式是使用内置的 new 函数，

表达式` new(T)` 创建一个未命名的 `T 类型变量`，初始化为 T 类型的零值，并返回其地址。

**所以 new() 函数返回的是一个指针**

```go
// 当你动态申请内存的时候，指针的存在意义之一就被体现出来了，此时并没有变量能直接指向这块内存，所以只能通过内存地址来访问

// 声明一个int变量，这个变量没有变量名，所以只能赋值给一个指针p,这个时候p是一个指针。
p := new(int)
// 通过 *p 取变量值，打印0
fmt.Println(*p)
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

生命周期是指程序执行过程中变量存在的时间段。包级别的变量的生命周期是程序的执行时间。局部变量的有一个动态的生命周期。



```go
// 这里 x 使用堆空间，因为它在f函数返回后，还可以从 global 变量访问，这种情况被称为 x 从 f 中逃逸。
var global *int 
func f(){
    var x int 
    x = 1 
    global = &x 
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

在程序运行期间，不能修改的量。

### 字面常量

所谓字面常量（literal），是指程序中硬编码的常量。

在其他语言中，常量通常有特定的类型，比如 `-12` 在C语言中会认为是一个 int 类型的常量。如果要指定一个值为`-12`的 long 类型常量，需要写成 `-12l`。

Go语言的字面常量更接近我们自然语言中的常量概念，它是无类型的。只要这个常量在相应类型的值域范围内，就可以作为该类型的常量。

Go的常量定义可以限定常量类型，但不是必需的。如果定义常量时没有指定类型，那么它与字面常量一样，是无类型常量。

常量定义的右值也可以是一个在编译期计算的常量表达式，如：

```go
const mask = 1 << 3
```

由于常量的赋值是一个编译期行为，所以右值不能出现任何需要运行期才能得出结果的表达式，比如试图以如下方式定义常量就会导致编译错误。

```go
// 编译错误
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



### 常量计数器

`iota` 是一个常量计数器，只能在常量的表达式中使用。

在每一个 const 关键字出现时被重置为0。然后在下一个 const 出现之前，每出现一次 iota ，其所代表的数字会自动增1。





 

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

| Type  | Size               | Range              |
| :---- | :----------------- | :----------------- |
| int8  | 8 bits             | -128 to 127        |
| int16 | 16 bits            | -2^15^ to 2^15^ -1 |
| int32 | 32 bits            | -2^31^ to 2^31^ -1 |
| int64 | 64 bits            | -2^63^ to 2^63^ -1 |
| int   | Platform dependent | Platform dependent |

#### 有符号整型

| Type   | Size               | Range              |
| :----- | :----------------- | :----------------- |
| uint8  | 8 bits             | 0 to 255           |
| uint16 | 16 bits            | 0 to 2^16^ -1       |
| uint32 | 32 bits            | 0 to 2^32^ -1      |
| uint64 | 64 bits            | 0 to 2^64^ -1      |
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

使用前缀 `0o` 或 `0O` 来表示八进制数，如 `0o70`

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



### 字符类型

严格来说，这并不是 Go 语言的一个类型，字符只是整数的特殊用例。

在 go 中，没有 char 这种字符类型，byte 和 rune 类型是 uint8 和 int32 的类型别名。

对于只占用 1 个字节的传统 ASCII 编码的字符来说，完全没有问题。例如：`var ch byte = 'A'`；字符使用单引号括起来。

在 ASCII 码表中，A 的值是 65，而使用 16 进制表示则为 41，所以下面的写法是等效的：

```go
var ch byte = 'A'  var ch byte = 65 或 var ch byte = '\x41'
```

 Go 同样支持 Unicode（UTF-8），因此字符同样称为 Unicode 代码点或者 runes，并在内存中使用 int 来表示。

```go
package main

import (
	"fmt"
    "reflect"
)

func main() {
	var a   , b  =  'a' , '中'
    var c byte = 'a'
	i,j := 0,1
	fmt.Println(j)
	fmt.Println(i)
	fmt.Println(a)
	fmt.Println(b)
    fmt.Println(c)
    fmt.Println("the type of i is :", reflect.TypeOf(i))
    fmt.Println("the type of a is :", reflect.TypeOf(a))
    fmt.Println("the type of b is :", reflect.TypeOf(b))
    fmt.Println("the type of c is :", reflect.TypeOf(c))
}

// 输出
1
0
97
20013
97
the type of i is : int
the type of a is : int32
the type of b is : int32
the type of c is : uint8

```





### 浮点数

Go语言支持两种浮点数 float32 和 float64 

32位浮点数最大值是 `math.MaxFloat32`

64位浮点数最大值是 `math.MaxFloat64` ,  // 默认Go语言中的小数都是 float64 类型



### nil

golang中的`nil`，很多人都误以为与Java、PHP 等编程语言中的null一样，但是实际上复杂很多，

`nil` 为预声明的标示符，定义在`builtin/builtin.go` 中。

```go
// nil is a predeclared identifier representing the zero value for a
// pointer, channel, func, interface, map, or slice type.
// Type must be a pointer, channel, func, interface, map, or slice type
var nil Type 

// Type is here for the purposes of documentation only. It is a stand-in
// for any Go type, but represents the same type for any given function
// invocation.
type Type int
```

#### nil的零值

按照Go语言规范，任何类型在未初始化时都对应一个零值：布尔类型是false，整型是0，字符串是""，而**指针、函数、interface、slice、channel和map的零值都是nil。**

Go 中的 nil 并不是一个关键字，



业务中一般将`nil`值表示为异常。nil值的大小始终与其类型与`nil`值相同的`non-nil`值大小相同。因此, 表示不同零值的nil标识符可能具有不同的大小。



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

4





### 字符串

Go语言中的字符串是原生数据类型，在内部实现使用 UTF-8 编码，相比之下， C/C++语言中并不存在原生的字符串类型，通常使用字符数组来表示，并以字符指针来传递。

**字符串的值必须以双引号包裹**

**Go语言中单引号包裹的是字符**

```go
// 字符串
s := "Hello World"

// 单独的字母，汉字，符号表示一个字符
c1 = 'h'
c2 = '1'

// 字符串的内容可以用类似于数组下标的方式获取

var s2 = s[0]  // s2="H"
```



多行字符串





#### 字符串转义符



|      |        |      |
| ---- | ------ | ---- |
| \n   | 换行符 |      |
|      |        |      |
|      |        |      |

#### 字符串常用操作

| 操作     | 方法                                    | 返回值                               |
| -------- | --------------------------------------- | ------------------------------------ |
| 长度     | len(s1)                                 | 返回字符串 s1 的长度                 |
| 拼接     | s1+s2 或者 fmt.Sprint( "%s%s", s1 , s2) | 返回新字符串                         |
| 分割     | strings.Split(s1 , "\\")                | 将 s1 字符串按 \ 分割                |
| 包含     | strings.Contains(s1, "Hello")           | 判断字符串中是否包含子串，返回布尔值 |
| 前缀判断 | fmt.HasPrefix(s1, "prefix")             | 判断字符串前缀中是否包含，返回布尔值 |
| 后缀判断 | strings.HasSuffix(s1,"suffix")          | 判断字符串后缀中是否包含，返回布尔值 |





### 数组

数组是Go语言编程中最常用的数据结构之一，指一系列同一类型数据的集合。

数组是一种非常有用的数据结构，因为其占用的内存是连续分配的。由于内存连续，CPU能把正在使用的数据缓存更久的时间。



```go
// 声明一个数组，每个元素为对应类型的零值
var array [5]int

// 声明并初始化
array1 := [5]int{10, 20, 30, 40, 50}

// 数组的容量由初始化的值计算出来
array2 := [...]int{10, 20, 30, 40, 50}

// 特定元素初始化，其余元素零值
array3 := [5]int{1: 10, 2: 20}

// 数组中的元素是指针类型
array4 := [5]*int{0: new(int), 1: new(int)}
*array[0] = 10
*array[1] = 20
```



**数组的操作**

在 Go 语言里，数组是一个值。这意味着数组可以用在赋值操作中。变量名代表整个数组。因此，同样类型的数组可以赋值给另一个数组

```go
// 声明第一个包含 4 个元素的字符串数组
var array1 [4]string

// 声明并初始化第二个字符串数组
array2 := [5]string{"Red", "Blue", "Green", "Yellow", "Pink"}

// 只有当数组长度相同，数组元素的类型相同时，才能赋值
// 将 array2 复制给 array1
array1 = array2


// 复制数值指针，只会复制指针值，
// array1和array2这两组指针，都指向这些字符值的内存地址

var array1 [3]*string

array2 := [3]*string{new(string), new(string), new(string)}

*array2[0] = "Red"
*array2[1] = "Blue"
*array2[2] = "Green"

array1 = array2
```



**在函数间传递数组**

根据内存和性能来看，在函数间传递数组是一个开销很大的操作。

数组是值类型，所有的值类型变量在赋值和作为参数传递时都将产生一次复制动作。



```go
// 声明一个10W个整型的数组，需要8MB空间
var array [1e6]int

// 将数组传递给函数 foo
foo(array)

// 函数 foo 接受一个 100 万个整型值的数组
func foo(array [1e6]int) {
	...
}

// 每次函数 foo 被调用时，必须在栈上分配 8 MB 的内存，将数组中的值复制到内存中。


// 这次函数接收的是指针，是一个指向 	100 万个整型值的数组的指针
var array [1e6]int
foo(&array)
func foo(array *[1e6]int) {
	...
}
```





```go

package main

import "fmt"

func modify(array [5]int)  {
	array[0] = 10
	fmt.Println("In modify function , array value is ",array)
	
}

func main()  {
	// 声明并初始化一个包含5个元素的整型数组
	array := [5]int {1,2,3,4,5}
	// 调用函数，实际并未修改原数组中的内容
	modify(array)
	// main函数打印数组，仍然是原数组的值
	fmt.Println("In main(), array values is", array)

}

```







### 切片



```go
// 基于数组创建切片
// 所有元素 mySlice = myArray[:] 
// 前n个元素 mySlice = myArray[:5]
// 从第n个元素开始，mySlice = myArray[5:]

// mySlice = myArray[x:y:z]
// 从第x个元素开始，第z个元素止，z-x是容量


// 直接创建切片
// make(元素类型,切片长度,切片容量)
mySlice1 := make([]int, 5)
// make(元素类型,切片长度) 长度和容量相同
mySlice2 := make([]int, 5, 10)


// 切片字面量
// 创建字符串切片，其长度和容量都是 5 个元素
slice := []string{"Red", "Blue", "Green", "Yellow", "Pink"}


//  cap(slice) 返回切片的容量, len(slice) 返回切片的长度




// nil切片
// 程序可能需要声明一个值为 nil 的切片，只要声明时不做任何初始化就会创建 nil 切片

// 创建 nil 整型切片
var slice []int
// 使用 make 创建空的整型切片变量
slice := make([]int, 0)
// 使用切片字面量创建空的整型切片变量
slice := []int{}



// 切片的 append 
// 切片是引用类型，切片的修改也会对底层数组进行修改
// 切片添加元素 , append() 第二个参数是一个不定长参数。所以 mySlice 是把第二个切片打散后传入
// append(oldSlice , value1,value2 ... valueN)
newSlice = append(newSlice, 60)
mySlice = append(mySlice, mySlice2...)
// 如果切片的底层数组没有足够的可用容量，append 函数会创建一个新的底层数组，将被引用的现有的值复制到新数组里
// 当这个 append 操作完成后，newSlice 拥有一个全新的底层数组，这个数组的容量是原来的两倍
// 函数 append 会智能地处理底层数组的容量增长。在切片的容量小于 1000 个元素时，总是会成倍地增加容量
// 一旦元素个数超过 1000，容量的增长因子会设为 1.25，也就是会每次增加 25% 的容量




// 切片的迭代

slice := []string {"apple", "green" , "yellow" , "pink"}

// 在迭代中只获取元素值
for _ , value := range slice{
	fmt.Printf("Value is %s\n",value)
}

// 从第 n 个元素开始迭代
for index := 2; index < len(slice) ; index++ {
	fmt.Printf("The Index %d of the Value is %s\n",index ,slice[index])
}



```



### map

在C++/Java中， map 一般都以库的方式提供，比如在C++中是STL的 std::map<> ，在C#中是Dictionary<> ，在Java中是 Hashmap<> ，在这些语言中，如果要使用 map ，事先要引用相应的库。

在Go中，使用 map 不需要引入任何库，并且用起来也更加方便。

**map 是一堆键值对的未排序集合。**可以用类似数组和切片的方式来迭代map中的元素。



```go
// 使用make声明一个map，键的类型是 string，值的类型是 int
dict := make(map[string]int)
// 声明一个存储能力为100的map
myMap = make(map[string] PersonInfo, 100)
// 声明并初始化map
dict := map[string]string{"Red": "#da1337", "Orange": "#e95a22"}

// 创建一个空map
colors := map[string]string{}
// 为map添加元素
colors["Red"] = "#da1337"

// map中的键不能是切片，函数，以及包含切片的结构类型。map中的值可以是任意类型
// 创建一个map，key是int,value是字符串切片
dict := map[int][]string{}


// 声明一个nil的map
var myMap map[string] PersonInfo


// 判断map中是否存在某个key
// 在其他语言中，判断值通常是三步：1.声明一个变量，2.从map中试图取值并赋给变量，3.判断该变量是否为空，如果为空则表示 map 中没有包含该变量
// 在go中，map["key"]返回两个值：value表示这个key对应的value，exits表示key是否存在
// 判断map中是否成功取到特定的键，不需要检查取到的值是否为 nil ，只需看第二个返回值 ok
value, exists := colors["Blue"]
// 这个键存在吗？
if exists {
	fmt.Println(value)
}
```





## 函数

函数构成代码执行的逻辑结构，在Go语言中，函数的基本组成为：关键字 func 、函数名、参数列表、返回值、函数体和返回语句。

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
// func 函数名，参数列表，返回值列表，函数体，返回语句


func functionName(parameter_list) (return_value_list) {
   …
}

// parameter_list 的形式为 (param1 type1, param2 type2, …)
// return_value_list 的形式为 (ret1 type1, ret2 type2, …)

// 只有当某个函数需要被外部包调用的时候才使用大写字母开头，并遵循 Pascal 命名法；
// 否则就遵循骆驼命名法，即第一个单词的首字母小写，其余单词的首字母大写。

func Add(a int, b int) (ret int, err error) {
	if a < 0 || b < 0 { 
		err= errors.New("Should be non-negative numbers!")
	return
	}
	return a + b, nil   // 支持多重返回
}
// Go语言并不需要强制命名返回值，但是命名后的返回值可以让代码更清晰，可读性更强，


// 调用多重返回函数时，可以忽略某个返回值
n, _ := f.Read(buf)


// 如果参数列表，返回值列表，中的多个参数的数据类型相同，可以合并
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

	r, _ = plus(a, b, c)
	fmt.Println(r)

}

func plus(x, y int, z int) (name int, fun func()) {
	sum1 := x + y + z
	f := func() {
		fmt.Println("hello world")
	}
    return sum1, f

}

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











## 结构体

Go 语言是一种静态类型的编程语言。这意味着，编译器需要在编译时知晓程序里每个值的类型。

值的类型给编译器提供两部分信息：第一部分，需要分配多少内存给这个值（即值的规模）；第二部分，这段内存表示什么。



Go 语言允许用户定义类型，当用户声明一个新类型时，这个声明就给编译器提供了一个框架，告知必要的内存大小和表示信息。



```go
// user 在程序里定义一个用户类型
// 结构类型通过组合一系列固定且唯一的字段来声明
type user struct {
	name       string
	email      string
	ext        int
	privileged bool
}

// 零值声明user类型的变量
var bill user

// 任何时候，创建一个变量并初始化为其零值，习惯是使用关键字 var
// 如果变量被初始化为某个非零值,就配合结构字面量和短变量声明操作符来创建变量

// 声明user类型的变量
Lisa := User{
	name:       "Lisa",
	email:      "lisa@email.com",
	ext:        123,
	privileged: true,
}

// 声明 user 类型的变量，这种形势，值的顺序必须和类型声明中的字段顺序一致
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







### 方法

关键字 func 和函数名之间的参数被称作接收者，将函数与接收者的类型绑在一起。如果一个函数有接收者，这个函数就被称为方法。

```go
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

































