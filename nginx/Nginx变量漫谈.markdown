# Nginx变量漫谈



Nginx 的配置文件使用的就是一门微型的编程语言，许多真实世界里的 Nginx 配置文件其实就是一个一个的小程序。

它在设计上受 Perl 和 Bourne Shell 这两种语言的影响很大。



熟悉 Perl、Bourne Shell、C/C++ 等命令式编程语言的朋友肯定知道，变量说白了就是存放“值”的容器。

而所谓“值”，在许多编程语言里，既可以是 `3.14` 这样的数值，也可以是 `hello world` 这样的字符串，甚至可以是像数组、哈希表这样的复杂数据结构。

然而，在 Nginx 配置中，变量只能存放一种类型的值，因为也只存在一种类型的值，那就是字符串。



比如我们的 `nginx.conf` 文件中有下面这一行配置：

```nginx
# 使用标准ngx_rewrite模块中的set配置指令对变量 $a 进行了赋值操作。
set $a "hello world";
```



Nginx 变量名前面有一个 `$` 符号，这是记法上的要求。**所有的 Nginx 变量在 Nginx 配置文件中引用时都须带上 `$` 前缀。**

这种表示方法和 Perl、PHP 这些语言是相似的。



虽然 `$` 这样的变量前缀修饰会让正统的 `Java` 和 `C#` 程序员不舒服，但这种表示方法的好处也是显而易见的，那就是可以直接把变量嵌入到字符串常量中以构造出新的字符串：

```nginx
# 声明一个变量a 
set $a hello;
# 用变量a的值来声明变量b
set $b "$a, $a";
```

这里我们通过已有的 Nginx 变量 `$a` 的值，来构造变量 `$b` 的值。

于是这两条指令顺序执行完之后，`$a` 的值是 `hello`，而 `$b` 的值则是 `hello, hello`

这种技术在 Perl 世界里被称为“变量插值”（variable interpolation），它让专门的字符串拼接运算符变得不再那么必要。

看一个比较完备的 nginx 配置文件示例：

```nginx
 server {
        listen 8080;

        location /test {
            set $foo hello;
        	// 使用echo配置指令将 $foo 变量的值作为当前请求的响应体输出
            echo "foo: $foo";
        }
    }


```

nginx echo 模块（这是一个第三方的nginx模块，如果是nginx，需要重新[编译安装](https://blog.csdn.net/jeikerxiao/article/details/106763068)，不过在 openresty 已经编译进去了） 

 https://github.com/openresty/echo-nginx-module#readme

```shell
# 使用curl访问这个地址，响应体返回nginx配置文件中声明的变量值
curl 'http://localhost:8080/test'
foo: hello
```



我们看到， [echo](http://wiki.nginx.org/HttpEchoModule#echo) 配置指令的参数也支持“变量插值”。不过，需要说明的是，并非所有的配置指令都支持“变量插值”。

事实上，指令参数是否允许”变量插值”，取决于该指令的实现模块。





Nginx 变量的规则：

- **Nginx 变量的创建和赋值操作发生在全然不同的时间阶段：**
  - **Nginx 变量的创建只能发生在 Nginx 配置加载的时候，或者说 Nginx 启动的时候；(Nginx启动的时候就会读取配置文件并加载)**
  - **Nginx 变量赋值操作则只会发生在请求实际处理的时候。**

- **Nginx 变量一旦创建，其变量名的可见范围就是整个 Nginx 配置，甚至可以跨越不同虚拟主机的 `server` 配置块。**

- **Nginx 变量名的可见范围虽然是整个配置，但每个请求都有所有变量的独立副本，或者说都有各变量用来存放值的容器的独立副本，彼此互不干扰。**

```nginx
   server {
        listen 8080;
        include mime.types;
		default_type text/html; 
		
        location /foo {
            echo "foo = [$foo]";
        }

        location /bar {
            set $foo 32;
            echo "foo = [$foo]";
        }
    }
```

这里我们在 `location /bar` 中用 `set` 指令创建了变量 `$foo`，于是在整个配置文件中这个变量都是可见的，因此我们可以在 `location /foo` 中直接引用这个变量而不用担心 Nginx 会报错。



```shell
# 由于 set 指令因为是在 location /bar 中使用的，所以赋值操作只会在访问 /bar 的请求中执行。
$ curl 'http://localhost:8080/foo'
    foo = []
# 这个URL匹配到 location /bar，所以成功使用set赋值
$ curl 'http://localhost:8080/bar'
    foo = [32]
# 即使前面请求了这两个URL，再次请求/foo。依然是空的。因为各个请求都有自己独立的 $foo 变量的副本。
$ curl 'http://localhost:8080/foo'
    foo = []
```



**对于 Nginx 新手来说，最常见的错误之一，就是将 Nginx 变量理解成某种在请求之间全局共享的东西，或者说“全局变量”。而事实上，Nginx 变量的生命期是不可能跨越请求边界的。**



### location 内部跳转



**关于 Nginx 变量的另一个常见误区是认为 "变量容器的生命期，是与 `location` 配置块绑定的"。其实不然。**我们来看一个涉及“内部跳转”的例子：

```nginx
   server {
        listen 8080;
		include mime.types;
		default_type text/html;
        location /foo {
            set $a hello;
        	# 如果直接请求/foo，则发生内部跳转，跳转到下面那个location
            echo_exec /bar;
        }

        location /bar {
            echo "a = [$a]";
        }
    }

```



这里我们在 `location /foo` 中，使用第三方模块 [ngx_echo](http://wiki.nginx.org/HttpEchoModule) 提供的 [echo_exec](http://wiki.nginx.org/HttpEchoModule#echo_exec) 配置指令，发起到 `location /bar` 的“内部跳转”。

**所谓“内部跳转”，就是在处理请求的过程中，在服务器内部，从一个 `location` 跳转到另一个 `location` 的过程。**

**这不同于利用 HTTP 状态码 `301` 和 `302` 所进行的“外部跳转”，因为后者是由 HTTP 客户端配合进行跳转的，而且在客户端，用户可以通过浏览器地址栏这样的界面，看到请求的 URL 地址发生了变化。**

内部跳转和 `Bourne Shell`（或 `Bash`）中的 `exec` 命令很像，都是“有去无回”。另一个相近的例子是 `C` 语言中的 `goto` 语句。



对于上面的例子，如果请求的是 `/foo` 这个接口，那么整个工作流程是这样的：

- 先在 `location /foo` 中通过 [set](http://wiki.nginx.org/HttpRewriteModule#set) 指令将 `$a` 变量的值赋为字符串 `hello`
- 后通过 [echo_exec](http://wiki.nginx.org/HttpEchoModule#echo_exec) 指令发起内部跳转，又进入到 `location /bar` 中，再输出 `$a` 变量的值。因为 `$a` 还是原来的 `$a`(hello)。

如果客户端直接请求 `/bar` 接口，就会得到空的 `$a` 变量的值，因为它依赖于 `location /foo` 来对 `$a` 进行初始化。





**一个请求在其处理过程中，即使经历多个不同的 `location` 配置块，它使用的还是同一套 Nginx 变量的副本。**

值得一提的是，标准 [ngx_rewrite](http://wiki.nginx.org/HttpRewriteModule) 模块的 [rewrite](http://wiki.nginx.org/HttpRewriteModule#rewrite) 配置指令其实也可以发起“内部跳转”，例如上面那个例子用 [rewrite](http://wiki.nginx.org/HttpRewriteModule#rewrite) 配置指令可以改写成下面这样的形式

```nginx
 server {
        listen 8080;
		include mime.types;
		default_type text/html;
        location /foo {
            set $a hello;
            rewrite ^ /bar;
        }

        location /bar {
            echo "a = [$a]";
        }
    }
```

从上面这个例子我们看到，Nginx 变量值容器的生命期是与当前正在处理的请求绑定的，而与 `location` 无关。



前面我们接触到的都是通过 [set](http://wiki.nginx.org/HttpRewriteModule#set) 指令隐式创建的 Nginx 变量。这些变量我们一般称为“用户自定义变量”，或者更简单一些，“用户变量”。

既然有“用户自定义变量”，自然也就有由 Nginx 核心和各个 Nginx 模块提供的“预定义变量”，或者说“内建变量”（builtin variables）。



### nginx 内置变量

所有的 nginx 内置变量都可以在[官方文档](http://nginx.org/en/docs/varindex.html)中找到。

Nginx 内建变量最常见的用途就是获取关于请求或响应的各种信息。

例如由 [ngx_http_core](http://nginx.org/en/docs/http/ngx_http_core_module.html) 模块提供的内建变量 [$uri](http://wiki.nginx.org/HttpCoreModule#.24uri)，可以用来获取当前请求的 URI（经过解码，并且不含请求参数），而 [$request_uri](http://wiki.nginx.org/HttpCoreModule#.24request_uri) 则用来获取请求最原始的 URI （未经解码，并且包含请求参数）。

比如：

```shell
  location /test {
        echo "uri = $uri";
        echo "request_uri = $request_uri";
    }
```

在这个例子中，把 [$uri](http://wiki.nginx.org/HttpCoreModule#.24uri) 和 [$request_uri](http://wiki.nginx.org/HttpCoreModule#.24request_uri) 的值输出到响应体中。

```shell
 $ curl 'http://localhost:8080/test'
    uri = /test
    request_uri = /test

$ curl 'http://localhost:8080/test?a=3&b=4'
    uri = /test
    request_uri = /test?a=3&b=4

$ curl 'http://localhost:8080/test/hello%20world?a=3&b=4'
    uri = /test/hello world
    request_uri = /test/hello%20world?a=3&b=4
```





另一个特别常用的内建变量其实并不是单独一个变量，而是有无限多变种的一群变量，即名字以 `arg_` 开头的所有变量。

**一个例子是 `$arg_name`，这个变量的值是当前请求名为 `name` 的 URI 参数的值，而且还是未解码的原始形式的值。**

```nginx
location /test {
        echo "name: $arg_name";
        echo "class: $arg_class";
    }
```

在命令行上使用各种参数组合去请求这个 `/test` 接口：

```shell
$ curl 'http://localhost:8080/test'
    name: 
    class: 

$ curl 'http://localhost:8080/test?name=Tom&class=3'
    name: Tom
    class: 3

$ curl 'http://localhost:8080/test?name=hello%20world&class=9'
    name: hello%20world
    class: 9
```

其实 `$arg_name` 不仅可以匹配 `name` 参数，也可以匹配 `NAME` 参数，抑或是 `Name`，等等：

> **Nginx 会在匹配参数名之前，自动把原始请求中的参数名调整为全部小写的形式。**

```shell
$ curl 'http://localhost:8080/test?NAME=Marry'
    name: Marry
    class: 

$ curl 'http://localhost:8080/test?Name=Jimmy'
    name: Jimmy
    class: 
```

如果你想对 URI 参数值中的 `%XX` 这样的编码序列进行解码，可以使用第三方 [ngx_set_misc](http://wiki.nginx.org/HttpSetMiscModule) 模块提供的 [set_unescape_uri](http://wiki.nginx.org/HttpSetMiscModule#set_unescape_uri) 配置指令：

```nginx
 location /test {
        set_unescape_uri $name $arg_name;
        set_unescape_uri $class $arg_class;

        echo "name: $name";
        echo "class: $class";
    }
```



现在我们再看一下效果：

```shell
$ curl 'http://localhost:8080/test?name=hello%20world&class=9'
    name: hello world
    class: 9
# 空格果然被解码出来
```

从这个例⼦我们同时可以看到，这个 set_unescape_uri 指令也像 set 指令那样，拥有⾃动创建 Nginx 变量的功能。

需要指出的是，许多内建变量都是只读的，比如我们刚才介绍的 [$uri](http://wiki.nginx.org/HttpCoreModule#.24uri) 和 [$request_uri](http://wiki.nginx.org/HttpCoreModule#.24request_uri). 对只读变量进行赋值是应当绝对避免的，因为会有意想不到的后果，比如：

```nginx
location /bad {
	set $uri /blah;
  	echo $uri;
  }
```

这个有问题的配置会让 Nginx 在启动的时候报出一条令人匪夷所思的错误：

```
[emerg] the duplicate "uri" variable in ...

```



# Nginx 配置指令的执行顺序



大多数 Nginx 新手都会频繁遇到这样一个困惑，那就是当同一个 `location` 配置块使用了多个 Nginx 模块的配置指令时，这些指令的执行顺序很可能会跟它们的书写顺序大相径庭。

于是许多人选择了“试错法”，然后他们的配置文件就时常被改得一片狼藉。这个系列的教程就旨在帮助读者逐步地理解这些配置指令背后的执行时间和先后顺序的奥秘。



```shell
location /test {
   set $a 32;
   echo $a;
   set $a 56;
   echo $a;
}
```



从这个例子的本意来看，我们期望的输出是一行 `32` 和一行 `56`，因为我们第一次用 [echo](http://wiki.nginx.org/HttpEchoModule#echo) 配置指令输出了 `$a` 变量的值以后，又紧接着使用 [set](http://wiki.nginx.org/HttpRewriteModule#set) 配置指令修改了 `$a`. 

事实并非如此：

```
    $ curl 'http://localhost:8080/test'
    56
    56
```









