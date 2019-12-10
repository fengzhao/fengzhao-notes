## Golang 连接 MySQL



### database/sql

`database/sql`是 Golang 的标准库之一，它提供了一系列接口方法，用于访问关系型数据库。它并不会提供数据库特有的方法，所有特有的方法交给数据库驱动去实现。

在Go中访问数据库需要用到`sql.DB`接口：它可以创建语句(statement)和事务(transaction)，执行查询，获取结果。

使用数据库时，除了`database/sql`包本身，还需要引入想使用的特定数据库驱动。官方不提供实现，先下载第三方的实现，[点击这里](https://github.com/golang/go/wiki/SQLDrivers)查看各种各样的实现版本。

`database/sql`库提供了一些 type ，这些类型对了解使用他的用法非常重要。

type类型有：

* DB 数据库对象，sql.DB 类型代表了数据库，和其他语言不一样，它并不是数据库的连接，golang中的连接来自内部实现的连接池，连接的建立是惰性的，并不是一直处于连接状态，当需要连接的时候，连接池会自动创建连接，一般来说不需要我们操作连接池，golang已经帮我们完成这一切了。调用 sql.Open 函数返回一个 DB 对象。
* Results 结果集。数据库查询的时候，都会有结果集，`sql.Rows`类型代表查询返回多行数据的结果集，`sql.Row`则表示单行查询结果的结果集，对于插入更新和删除，返回的结果集类型为`sql.Result`
* Statements语句，`sql.stmt`类型代表 sql 查询语句，例如 DDL，DML 等类似的 sql 语句，



```shell
# 安装驱动包
go get -u github.com/go-sql-driver/mysql
```



```go
package main

import (
    "database/sql"
    "encoding/json"
    "fmt"
    "strings"
    
    _ "github.com/go-sql-driver/mysql"
    "github.com/pkg/errors"
    
)
// import 下划线（如：import _ github/demo）的作用：
//	    当导入一个包时，该包下的文件里所有init()函数都会被执行，然而，有些时候我们并不需要把整个包都导入进来，仅仅是是希望它执行init()函数而已。这个时候就可以使用 import _ 引用该包。
//	    上面的mysql驱动中引入的就是mysql包中各个init()方法，你无法通过包名来调用包中的其他函数。
//	    导入时，驱动的初始化函数会调用 sql.Register 将自己注册在 database/sql 包的全局变量 sql.drivers 中，以便以后通过 sql.Open 访问。



//数据库配置
const (
	USERNAME = "root"
	PASSWORD = "123456"
	NETWORK = "tcp"
	SERVER = "127.0.0.1"
	PORT = 3306
	DATABASE = "test"
)


//user表结构体定义
type User struct {
	Id int `json:"id" form:"id"`
	Username string `json:"username" form:"username"`
	Password string `json:"password" form:"password"`
	Status int   `json:"status" form:"status"`      // 0 正常状态， 1删除
	Createtime int64 `json:"createtime" form:"createtime"`
}

func main() {
	conn := fmt.Sprintf("%s:%s@%s(%s:%d)/%s",USERNAME, PASSWORD, NETWORK, SERVER, PORT, DATABASE)
	DB, err := sql.Open("mysql", conn)
	if err != nil {
		fmt.Println("connection to mysql failed:", err)
		return
	}
	
    DB.SetConnMaxLifetime(100*time.Second)  //最大连接周期，超时的连接就close
    DB.SetMaxOpenConns(100)                //设置最大连接数
    CreateTable(DB)
    InsertData(DB)
    QueryOne(DB)
    QueryMulti(DB)
    UpdateData(DB)
    DeleteData(DB)
}
// 建表
func CreateTable(DB *sql.DB) {
	sql := `CREATE TABLE IF NOT EXISTS users(
	id INT(4) PRIMARY KEY AUTO_INCREMENT NOT NULL,
	username VARCHAR(64),
	password VARCHAR(64),
	status INT(4),
	createtime INT(10)
	); `
	
	if _, err := DB.Exec(sql); err != nil {
        fmt.Println("create table failed:", err)
        return
    }
	fmt.Println("create table successd")
}

//插入数据
func InsertData(DB *sql.DB) {
    result,err := DB.Exec("insert INTO users(username,password) values(?,?)","test","123456")
    if err != nil{
        fmt.Printf("Insert data failed,err:%v", err)
        return
    }
    lastInsertID,err := result.LastInsertId()    //获取插入数据的自增ID
    if err != nil {
        fmt.Printf("Get insert id failed,err:%v", err)
        return
    }
    fmt.Println("Insert data id:", lastInsertID)
   
    rowsaffected,err := result.RowsAffected()  //通过RowsAffected获取受影响的行数
    if err != nil {
        fmt.Printf("Get RowsAffected failed,err:%v",err)
        return
    }
    fmt.Println("Affected rows:", rowsaffected)
}

//查询单行
func QueryOne(DB *sql.DB) {
	user := new(User)   //用new()函数初始化一个结构体对象
	row := DB.QueryRow("select id,username,password from users where id=?", 1)
	//row.scan中的字段必须是按照数据库存入字段的顺序，否则报错
	if err := row.Scan(&user.Id,&user.Username,&user.Password); err != nil {
		fmt.Printf("scan failed, err:%v\n", err)
		return
	}
	fmt.Println("Single row data:", *user)
}

//查询多行
func QueryMulti(DB *sql.DB) {
    user := new(User)
    rows, err := DB.Query("select id,username,password from users where id = ?", 2)
    
    defer func() {
        if rows != nil {
            rows.Close()   //关闭掉未scan的sql连接
        }
    }()
    if err != nil {
        fmt.Printf("Query failed,err:%v\n", err)
        return
    }
    for rows.Next() {
        err = rows.Scan(&user.Id, &user.Username, &user.Password)  //不scan会导致连接不释放
        if err != nil {
            fmt.Printf("Scan failed,err:%v\n", err)
            return
        }
        fmt.Println("scan successd:", *user)
    }
}

//更新数据
func UpdateData(DB *sql.DB){
    result,err := DB.Exec("UPDATE users set password=? where id=?","111111",1)
    if err != nil{
        fmt.Printf("Insert failed,err:%v\n", err)
        return
    }
    fmt.Println("update data successd:", result)
    
    rowsaffected,err := result.RowsAffected()
    if err != nil {
        fmt.Printf("Get RowsAffected failed,err:%v\n",err)
        return
    }
    fmt.Println("Affected rows:", rowsaffected)
}

//删除数据
func DeleteData(DB *sql.DB){
    result,err := DB.Exec("delete from users where id=?",1)
    if err != nil{
        fmt.Printf("Insert failed,err:%v\n",err)
        return
    }
    fmt.Println("delete data successd:", result)
    
    rowsaffected,err := result.RowsAffected()
    if err != nil {
        fmt.Printf("Get RowsAffected failed,err:%v\n",err)
        return
    }
    fmt.Println("Affected rows:", rowsaffected)
}





```





