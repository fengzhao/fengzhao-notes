## MySQL用户管理



在 MySQL 8.0 中，`caching_sha2_password` 是默认的身份验证插件，而不是之前版本的 `mysql_native_password`，默认的密码加密方式是 `SHA2` 。

如果需要保持以前版本的密码加密方式，需要在配置文件中显示指定  default_authentication_plugin = mysql_native_password ，并重启生效。

将 MySQL 8.0 中已有的 `SHA2` 密码修改为 `SHA1` 的模式。

```sql
-- 更新用户的密码加密方式为之前版本的方式
mysql> ALTER USER 'root'@'127.0.0.1' IDENTIFIED WITH mysql_native_password BY 'password';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'sj@36668182';


alter user root@'%' IDENTIFIED WITH mysql_native_password BY 'sj36668182';
-- 刷新权限
mysql> FLUSH PRIVILEGES;

```

> 注：此选项暂不支持 MySQL 8.0 动态修改特性。
>
> 注：如果没有特殊的原因，建议使用更安全的新加密方式。



### 用户管理

```sql

-- 建用户
CREATE USER 'dba'@'%' IDENTIFIED WITH 'mysql_native_password' by 'admin@123' ;

-- 赋超级权限
GRANT ALL PRIVILEGES ON *.* TO 'dba'@'%';
 
CREATE USER 'shendandan'@'192.168.%' IDENTIFIED WITH 'mysql_native_password' by 'admin@123' ;

-- 指定密码过期，以便用户第一次使用的时候需要修改密码
CREATE USER 'jeffrey'@'localhost' IDENTIFIED WITH 'caching_sha2_password' BY 'new_password' PASSWORD EXPIRE DEFAULT;

-- 不使用加密连接
CREATE USER 'dba'@'%' IDENTIFIED WITH 'mysql_native_password' by 'admin@123'  REQUIRE NONE ;
-- 使用加密连接
CREATE USER 'dba'@'%' IDENTIFIED WITH 'mysql_native_password' by 'admin@123'  REQUIRE NONE ;






-- 创建用户并且设置资源闲置（如果不带资源选项，默认不限制资源）

-- 单位小时内账户被允许查询500次
-- 单位小时内账户被允许更新100次
-- 单位小时内最大连接数不限制
-- 同一时刻最大并发连接数不限制


CREATE USER 'jeffrey'@'%' 

IDENTIFIED WITH 'mysql_native_password' by 'admin@123'

WITH 
	MAX_QUERIES_PER_HOUR 500 
	MAX_UPDATES_PER_HOUR 100 
	MAX_CONNECTIONS_PER_HOUR 0 
	MAX_USER_CONNECTIONS 0;





-- 锁定用户
CREATE USER 'jeffrey'@'localhost' ACCOUNT LOCK
-- 解锁用户
ALTER USER 'jeffrey'@'localhost' ACCOUNT UNLOCK

-- 删除用户
DROP USER 'jeffrey'@'localhost';

-- 修改用户
RENAME USER 'jeffrey'@'localhost' TO 'jeff'@'127.0.0.1';


-- 修改当前用户自己账号的密码
ALTER USER USER() IDENTIFIED BY 'new_password';

-- 修改其他用户账号的密码
ALTER USER 'jeffrey'@'localhost' IDENTIFIED BY 'new_password';

-- 修改用户认证插件
ALTER USER 'jeffrey'@'localhost' IDENTIFIED WITH mysql_native_password;

-- 修改密码和插件
ALTER USER 'jeffrey'@'localhost' IDENTIFIED WITH mysql_native_password BY 'new_password';





-- 详细语法

CREATE USER [IF NOT EXISTS]
    user [auth_option] [, user [auth_option]] ...
    DEFAULT ROLE role [, role ] ...
    [REQUIRE {NONE | tls_option [[AND] tls_option] ...}]
    [WITH resource_option [resource_option] ...]
    [password_option | lock_option] ...

user:
    (see Section 6.2.4, “Specifying Account Names”)

auth_option: {
    IDENTIFIED BY 'auth_string'
  | IDENTIFIED WITH auth_plugin
  | IDENTIFIED WITH auth_plugin BY 'auth_string'
  | IDENTIFIED WITH auth_plugin AS 'hash_string'
}

tls_option: {
   SSL
 | X509
 | CIPHER 'cipher'
 | ISSUER 'issuer'
 | SUBJECT 'subject'
}

resource_option: {
    MAX_QUERIES_PER_HOUR count
  | MAX_UPDATES_PER_HOUR count
  | MAX_CONNECTIONS_PER_HOUR count
  | MAX_USER_CONNECTIONS count
}

password_option: {
    PASSWORD EXPIRE [DEFAULT | NEVER | INTERVAL N DAY]
  | PASSWORD HISTORY {DEFAULT | N}
  | PASSWORD REUSE INTERVAL {DEFAULT | N DAY}
  | PASSWORD REQUIRE CURRENT [DEFAULT | OPTIONAL]
}

lock_option: {
    ACCOUNT LOCK
  | ACCOUNT UNLOCK
}
```



### 角色管理



MySQL 8.0 引入了 RBAC（Role-Based Access Control） ， 中文译名就是**基于角色的权限访问控制**。

简单说，就是把一组权限赋给角色，角色并不能直接登陆，然后把用户权限赋给角色。

```sql

-- 应用程序需要读/写权限。
-- 运维人员需要完全访问数据库。
-- 部分开发人员需要读取权限。
-- 部分开发人员需要读写权限。

-- 创建四个角色。为了清楚区分角色的权限，建议将角色名称命名得比较直观。

-- 创建角色
CREATE ROLE 'app', 'ops', 'dev_read', 'dev_write';

-- 把权限授予角色
 GRANT SELECT, INSERT, UPDATE, DELETE ON wordpress.* TO 'app';
 GRANT ALL PRIVILEGES ON wordpress.* TO 'ops';
 GRANT SELECT ON wordpress.* TO 'dev_read';
 GRANT INSERT, UPDATE, DELETE, select , index , create ,view ,  ON wordpress.* TO 'dev_write';

-- 根据实际情况，将用户加入到角色中，用户将获取角色的权限
GRANT app TO 'app01'@'%';
GRANT ops TO 'ops01'@'%';
GRANT dev_read TO 'dev01'@'%';



--移除角色
DROP ROLE 'admin', 'dev';
```



