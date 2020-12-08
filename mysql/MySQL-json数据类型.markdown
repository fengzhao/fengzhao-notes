## json



MySQL 5.7.8  增加了 JSON 数据类型的支持，在之前如果要存储 JSON 类型的数据的话我们只能自己做 `JSON.stringify()` 和 `JSON.parse()` 的操作



```sql
-- 建表

CREATE TABLE user (
  id INT(11) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(30) NOT NULL,
  info JSON
);




INSERT INTO user (`name`, `info`) VALUES(
    'lilei', 
    '{"sex": "male", "age": 18, "hobby": ["basketball", "football"], "score": [85, 90, 100]}'

);

```



