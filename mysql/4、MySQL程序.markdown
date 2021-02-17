## MySQL 程序概览 

MySQL 安装目录下的 /bin 目录中有很多二进制的可执行程序，每个操作系统平台的 mysql 版本中都有这些可执行文件，除了少数是平台专用的（例如，数据库启动脚本在 windows 上就不适用，在 windows 中通常的做法是把 mysql 注册成系统服务，然后配置成开机自启）。每一个可执行程序都可以在终端中执行，通过 --help 来查看命令帮助，可以在命令中显式指定参数或者在配置文件中指定，来覆盖命令的默认参数。

其中 mysql 和 mysqld 是两个重要的程序，这两个分别是 mysql 客户端程序和服务端程序。



#### 启动或者停止类程序

- mysqld  服务端守护进程的程序（即MySQL Server）
- mysqld_safe 服务端启动脚本，这个脚本尝试去启动 mysqld 守护进程程序。
- mysql.server 服务器启动脚本，主要是设置操作系统的开机自启任务，它调用 mysqld_safe 去启动守护进程
- mysql.multi 多实例管理脚本，用于管理单机多实例的启动或停止



#### 安装或者升级时的程序

-  mysql_install_db  系统初始化程序，这个程序会生成数据目录，创建 mysql 系统数据库，初始化默认权限

> mysql_install_db 这个程序在 MySQL 5.7.6 中已经弃用，因为它的功能已经集成在 mysqld 中了，所以在安装 5.7 时，直接使用  mysqld --initialize  或者  mysqld  --initialize-insecure 就可以直接初始化。
>
> 在 5.7.5 之前，这个程序是用 perl 脚本写的，所以需要安装 perl ，5.7.5 之后，改为用 C++ 写的，并且可以直接做为二进制文件执行。

-  mysql_plugin  这个程序用来配置管理服务端插件
-  mysql_secure_installation  这个程序用来提升安装过程的安全性
-  mysql_ssl_rsa_setup  这个程序用来生成 ssl 证书和密钥文件，主要用于数据库的 SSL 安全连接
-  mysql_upgrade  这个程序在 MySQL 升级时使用。



#### 客户端程序

- mysql  交互式的客户端工具，登陆后可以执行各种sql命令
- mysqladmin  执行管理操作的客户端程序，创建，删除数据库，重载授权表等操作
- mysqlcheck   表维护工具，例如检查，修复，分析，优化表等
- mysqldump  数据库备份工具，将 mysql 库导出为 sql 文件
- mysqlimport  可以使用与 load data 一样的方式向 mysql 数据库中导入数据
- mysqlshow  一个可以显示出数据库，表，列，索引等元数据信息的程序
- mysqlpump  



## 使用 MySQL 程序

### 解析 MySQL 程序

在命令行中使用 mysql 程序，参数可能用 - 或 -- 前缀来指定参数选项，也存在没有前缀选项的参数，这种提供了一些额外的信息，例如 mysql 程序检测到第一个没有选项的参数，会把这个参数当作要操作的数据库名称。所以 mysql --user=root test 这个命令指定要操作的数据库是 test 。

很多参数选项对一些程序都是通用的，最常用的是 --host(-h), --user(-u),--password(-p) ,--port(-P),--socket(-S)，这个用来指定连接选项，对所有的客户端程序都可以适用。指定连接的主机，用户名，密码，端口，套接字文件。

默认安装后，只能在mysql的 bin 目录下才可以允许这些程序，所以需要把这个目录添加到操作系统的环境变量 PATH中，这样就可以在任何路径下都可以执行二进制文件。在 Linux 中可以用 bash 终端命令行，在 Windows 中可以用 cmd 命令行。



### 连接到 mysql 服务器

对于一个客户端程序，连接 mysql 的时候，需要提供一些参数（主机IP，端口，用户名，密码）。每个参数都有默认值，可以通过在命令行中重写或在配置文件中指定好。下面以 mysql 这个客户端程序为例，其他的客户端程序同样也适用。

```shell
mysql 
```

直接在命令行中调用这个命令，如果不带参数，参数直接适用默认值：

- 默认主机是 localhost , 
- 默认用户名，在 windows 中是 ODBC ，在 Unix 中是当前 shell 登陆的用户名。
- 如果 -p 或 --password 没指定，表示没有密码。
- 对于 mysql程序，第一个无选项参数被认定为登陆后要选中操作的默认数据库

可以使用以下两种方式来登陆：

```shell
mysql --host=localhost --user=myname --password=password mydb
mysql -h localhost -u myname -ppassword mydb
```

如果在命令使用 -p 选项指定密码，那么在 --password= 和 -p 后直接跟密码，不能带空格。

如果不在命令中跟密码，那么 mysql 程序会交互式弹出密码输入框。这种方式是可取的。

在一些操作系统中，直接在 mysql 命令中指定密码是不安全的，其他用户可以通过 ps 等命令显示出你输入的明文密码。所以终端中，尽量避免使用 --password=password 和 -ppassword 这种格式。

在一些操作系统中，限制了在终端中输入的密码数最大是8位字符，这是系统限制，并不是 mysql 限制。在 mysql 内部并没有密码长度的限制。为了解决这类问题，把密码调整到符合系统限制或者放到配置文件中即可。





### 指定参数

有很多种方式可以给 MySQL 程序指定参数：

- 在命令行中直接指定参数，通常是 MySQL 程序后跟参数以及参数选项。
- 在配置文件中指定，程序一启动就会去读配置文件。
- 在环境变量（MySQL内部变量）中列出选项



选项按照顺序被处理：

- 如果在命令中多次指定同一个参数选项，那么以最后一个为准。

- 如果参数选项冲突，后一个参数有更高的优先级。

MySQL程序先找环境变量，再找配置文件，最后通过命令行传参。

这意味着环境变量的优先级最低，命令行参数的优先级最高。

可以通过在配置文件中为程序指定默认参数，这样就可以避免每次执行命令时都要输入一大堆参数，如果需要改参数时，可以直接在命令行中指定来覆盖默认参数。

> 在早期的 MySQL 版本中，程序的参数可以使用完整名称或参数前缀，例如使用 mysqldump --compress 也可以写成 mysqldump --compr，但是不能用 --comp ，因为还不足以识别出来是这个参数。在 MySQL 5.7 中，不再支持参数前缀。



### 在命令行中指定参数

在命令行中指定参数需要遵循以下规则：

- 参数跟在命令后面。

- 参数可以使用 -- 长选项或 - 短选项。很多选项都支持长选项和短选项。例如：-？ 和 --help 都是表示显示该命令的帮助，一个是短选项，一个是长选项。

- 参数选项区分大小写，-v 和 -V 在很多程序中都有不同含义，分别表示(--verbose和--version)。

- 很多选项后面都可以跟参数值，例如： -h localhost 或 --host=localhost 表示要连接的主机地址。

- 对于长选项，在选项跟参数值之间使用 = 号连接，对于短选项，选项和参数之间可以带一个空格或不带空格。-hlocalhost 和 -h localhost 是等价的。唯一例外的就是指定密码的时候，只能使用 -ppassword 或 --password=password 这两种格式。

- 对于选项名称，- 号和 _ 号是等价的， --skip-grant-tables 和 -- skip_grant_tables 是等价的。（但是最前面的 - 号不能用 _ 号代替）。

- 对于一些需要指定数值的参数，可以使用 K,M,G 等后缀来表示 1024 ，1024^2，1024^3 。

- 当指定文件名的时候，不要用 ~ 之类的 shell 元字符来指定。

  参数选项中出现空格的地方需要用引号引起来，例如：--execute (or -e) 选项可以使 mysql 这个客户端程序传一个 sql 语句给服务端执行。当使用这个选项时，必须要用引号把后面的 sql 语句括起来。



### 参数选项修饰

很多参数选项是 boolean 类型，用来控制某个功能的开关。例如，mysql 客户端程序使用一种  --column-names  来决定查询结果是否有标题，默认地，它是开启的。可以通过如下格式来关闭它：

```sql
--disable-column-names
--skip-column-names
--column-names=0
```

-- disable 前缀，--skip前缀，=0 后缀 ，都有一个效果，那就是关闭这个功能。

启用这个功能也有如下三种格式：

```sql
--column-names
--enable-column-names
--column-names=1
```

ON, TRUE, OFF, FALSE 都被认为是 boolean 类型，不区分大小写。

如果一个参数以 --loose 前缀开头，如果命令不能识别这个参数，也不会报错退出，只会提示 warn 警告一下。

```sql
shell> mysql --loose-no-such-option
mysql: WARNING: unknown option '--loose-no-such-option'
```



### 使用配置文件

很多 mysql 程序都可以从 mysql 配置文件中读取相关参数，把参数写在配置文件中就可以避免每次执行命令都要输入参数。

判断一个程序是否从配置文件中读取参数，使用 --help 来查看帮助（对于 mysqld，使用 --verbose 和 --help），如果一个程序都配置文件中读参数，那么它会显示它从哪些路径寻找配置文件，以及识别到的选项组。

```shell
[root@localhost ~]# mysql --help --verbose | grep -C 10 /etc/my.cnf
                      and also turns off parsing of all clientcommands except
                      \C and DELIMITER, in non-interactive mode (for input
                      piped to mysql or loaded using the 'source' command).
                      This is necessary when processing output from mysqlbinlog
                      that may contain blobs.
  --connect-expired-password
                      Notify the server that this client is prepared to handle
                      expired password sandbox mode.

Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
The following groups are read: mysql client
The following options may be given as the first argument:
--print-defaults        Print the program argument list and exit.
--no-defaults           Don't read default options from any option file,
                        except for login file.
--defaults-file=#       Only read default options from the given file #.
--defaults-extra-file=# Read this file after the global files are read.
--defaults-group-suffix=#
                        Also read groups with concat(group, suffix)
--login-path=#          Read this path from the login file.
[root@localhost ~]#

```





很多配置文件都是纯文本的，使用任意一种编辑器都可以编辑。有一个例外的是  .mylogin.cnf 文件，这是一个需要通过 mysql_config_editor 工具来创建的加密文件



MySQL 查找配置文件时，都会按照一定的查找顺序。

| 配置文件路径        | 目的                                   |
| ------------------- | -------------------------------------- |
| /etc/my.cnf         | 全局                                   |
| /etc/mysql/my.cnf   | 全局                                   |
| SYSCONFDIR/my.cnf   | 全局                                   |
| $MYSQL_HOME/my.cnf  | 仅适用于服务端                         |
| defaults-extra-file | 通过  --defaults-extra-file 参数指定   |
| ~/.my.cnf           | 用户配置文件                           |
| ~/.mylogin.cnf      | 用户登录配置文件（仅适用于客户端程序） |

SYSCONFDIR 目录指采用 cmake 编译安装时  SYSCONFDIR 这个编译参数指定的目录。默认是 /etc/ 目录。

MYSQL_HOME 是一个系统环境变量，主要作用是声明  my.cnf 配置文件的路径，如果没有设置，并且通过 mysqld_safe 启动的数据库，一般是指向 MySQL 的 basedir ，



任何一个在命令行中可以用长选项指定的参数都可以在配置文件中指定，查看一个程序的可用参数，在运行时使用 --help 选项查看所有参数的帮助。（对于 mysqld ，使用  --verbose 和 --help 一起）。



在命令中指定参数和配置文件中指定参数的语法是类似的，但是不需要用 -- 前缀，并且每一行只有一个参数。例如：命令行中的 --quick and --host=localhost ，在配置文件中直接用 quick 和  host=localhost  就可以了。

配置文件中的空行会被忽略，非空行按照如下规则：

- 注释行以 # 开头。
- [group]  指定某个程序下的参数，在每个 group 下的每一行参数，都会在运行这个程序的时候匹配。
- 配置文件通常都是 opt_name=value 键值对的格式，有时候也可以用 “” 引号把 value 引起来。



例如：

[mysqld] 和 [mysql] 下的参数，分别在运行 mysqld 程序（服务端）和 mysql程序（客户端）时匹配。

[client] 参数组会被所有 mysql 客户端程序所匹配。**前提是所有客户端都可以识别这个参数**

譬如：当客户端程序要连接数据库时，[client] 是最好的存密码的方式（前提是这个配置文件只能你自己访问）

下面是一个全局的配置文件示例：

```shell
[client]
port=3306
socket=/tmp/mysql.sock
[mysqld]
port=3306
socket=/tmp/mysql.sock
key_buffer_size=16M
max_allowed_packet=8M
[mysqldump]
quick
```

下面是一个用户配置文件示例：

```she
[client]
# The following password will be sent to all standard MySQL clients
password="my password"
[mysql]
no-auto-rehash
connect_timeout=2
```



也可以在配置文件中使用 !includedir 指令来包含其他路径的配置文件。这样做就是配置文件分层。



### 控制配置文件的命令行参数



很多 mysql 程序都支持用配置文件来指参数。但是配置文件本身也是用参数控制的，所以这类参数一般不能在配置文件中指定，要在命令行中指定，通常，这类参数的顺序应该在命令行后的第一个，























