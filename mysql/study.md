排序规则 collate

> utf8_general_ci

ci 后缀  Case Insensitive 大小写无关

cs  Case Sensitive 大小写敏感



ORDER BY 

LIMIT 

OFFSET

GROUP BY


简答查询

```mysql
/*websites  表名   name alexa url country  字段*/
SELECT * FROM websites;                      /* 查询表所有数据 */

SELECT name FROM websites;                   /* 查询表字段数据 */

SELECT * FROM websites WHERE name = "广西";   /* 查询表字段下条件数据 */

SELECT * FROM websites WHERE name like "_o%"; /* 模糊查询表下数据 */

SELECT * FROM websites WHERE id BETWEEN "1" AND "5";    /* 查询表下字段范围数据 */

SELECT * FROM websites WHERE name in ("广西","百度");    /* 查询表字段下固定条件数据 */

SELECT DISTINCT country FROM Websites;                  /* 查询去重值 */

SELECT * FROM Websites WHERE country = "CN" AND alexa > 50;  /*查询表下范围条件数据*/

SELECT * FROM Websites WHERE country = "USA" OR country="sh"; /* 查询表下条件不同值 */

SELECT * FROM Websites ORDER BY alexa;                      /* 查询表下值排序结果 */

SELECT * FROM Websites ORDER BY alexa DESC;                 /* 查询表下排序结果降序 */

SELECT * FROM Websites LIMIT 2;      /* 查询表下范围数据 */

SELECT name as zzz from websites;    /*别名查询表下数据*/

 /* 组合使用 */
SELECT DISTINCT worker_name AS KKK FROM roster_worker ORDER BY worker_name DESC;
```

数据库查询哪一部分的数据。

```
select*from  表名  order by 字段  （倒序/升序） limit   start,count;
```

查询数据库中学生表逆序的 5 条数据：

```
select*from student order by id desc limit 0,5;
```

-  order by id: 通过id来查询
-  desc: 表示倒序，可替换成 asc ，表示升序
-  start: 开始（升序第一条是0，降序最后一条是0）
-  count: 查询的个数

```mysql
mysql> select*from student;
+----+--------+------+
| id | name   | age  |
+----+--------+------+
| 16 | gege   |   50 |
| 18 | didi   |   23 |
| 19 | gege   |   23 |
| 20 | yeye   |   23 |
| 21 | jiujiu |  101 |
| 25 | gege   |   13 |
| 29 | kaka   |    2 |
| 32 | haha   |   20 |
| 33 | ghg    |   20 |
| 34 | dijia  |   20 |
| 38 | daina  |   20 |
+----+--------+------+
11 rows in set (0.00 sec)
mysql> select*from student order by id desc limit 0,5;

+----+-------+------+
| id | name  | age  |
+----+-------+------+
| 38 | daina |   20 |
| 34 | dijia |   20 |
| 33 | ghg   |   20 |
| 32 | haha  |   20 |
| 29 | kaka  |    2 |
+----+-------+------+
5 rows in set (0.00 sec)
```

子查询

```mysql
SELECT * FROM articles WHERE  id >=
 (SELECT id FROM articles  WHERE category_id = 123 ORDER BY id LIMIT 10000, 1) LIMIT 10;
 
 
SELECT * FROM roster_worker WHERE  worker_id >=
 (SELECT worker_id FROM roster_worker  WHERE worker_company = 'WE' ORDER BY worker_id LIMIT 10, 1) LIMIT 10;
```

关联查询

左关联: **left join ... on ...**

右关联: **right join... on ...**

```mysql
select 字段 from 表1 left join 表2 on  条件 (一般为表1与表2的关联条件)
```

例如：

查询用户的所有订单信息 :

```mysql
/**
	user 用户表
	orders 订单表
*/
select * from user left join orders on user.id = orders.user_id 
```

稍微复杂点 统计用户的订单数量 (需要分组,通过用户的id)

```mysql
mysql> select user.username,orders.id,count(*) from user right join orders on user.id = orders.user_id GROUP BY user.id;
+----------+----+----------+
| username | id | count(*) |
+----------+----+----------+
| 王五     |  3 |        2 |
| 张三     |  5 |        1 |
+----------+----+----------+
2 rows in set (0.07 sec)
```

这里显示名为王五(id=3)的用户有2个订单 张三(id=5)1个订单

这里是右关联查询,用右关联查询是有道理的, 因为左关联和有关联 是有差别的查询,区别:left join on 左边的表为主表 right join on 右边的表为主表

这个统计订单的查询有一个问题 就是 用户表中有用户新信息,但是这个用户没有订单信息

请看下面的查询;

```mysql
---------------------
单表查询
---------------------
mysql> select * from user;
+----+----------+------------+------+----------+
| id | username | birthday   | sex  | address  |
+----+----------+------------+------+----------+
|  1 | 王五     | 2017-11-25 | 3    | 南阳     |
| 10 | 张三     | 2014-07-10 | 1    | 北京市   |
| 16 | 张小明   | NULL       | 1    | 河南郑州 |
| 22 | 陈小明   | NULL       | 1    | 河南郑州 |
| 24 | 张三丰   | NULL       | 1    | 河南郑州 |
| 25 | 陈小明   | NULL       | 1    | 河南郑州 |
| 26 | 王五     | NULL       | NULL | NULL     |
| 29 | 小黑     | 2017-11-26 | NULL | NULL     |
| 30 | 抖森     | 2017-11-25 | 1    | 山村     |
+----+----------+------------+------+----------+
9 rows in set (0.03 sec)

mysql> select * from orders;
+----+---------+---------+---------------------+------+
| id | user_id | number  | createtime          | note |
+----+---------+---------+---------------------+------+
|  3 |       1 | 1000010 | 2015-02-04 13:22:35 | NULL |
|  4 |       1 | 1000011 | 2015-02-03 13:22:41 | NULL |
|  5 |      10 | 1000012 | 2015-02-12 16:13:23 | NULL |
+----+---------+---------+---------------------+------+
3 rows in set (0.03 sec)
--------------------------
关联查询
-------------------------
左关联
------------------------
mysql> select user.* ,orders.number from user  left join orders on user.id = orders.user_id;
+----+----------+------------+------+----------+---------+
| id | username | birthday   | sex  | address  | number  |
+----+----------+------------+------+----------+---------+
|  1 | 王五     | 2017-11-25 | 3    | 南阳     | 1000010 |
|  1 | 王五     | 2017-11-25 | 3    | 南阳     | 1000011 |
| 10 | 张三     | 2014-07-10 | 1    | 北京市   | 1000012 |
| 16 | 张小明   | NULL       | 1    | 河南郑州 | NULL    |
| 22 | 陈小明   | NULL       | 1    | 河南郑州 | NULL    |
| 24 | 张三丰   | NULL       | 1    | 河南郑州 | NULL    |
| 25 | 陈小明   | NULL       | 1    | 河南郑州 | NULL    |
| 26 | 王五     | NULL       | NULL | NULL     | NULL    |
| 29 | 小黑     | 2017-11-26 | NULL | NULL     | NULL    |
| 30 | 抖森     | 2017-11-25 | 1    | 山村     | NULL    |
+----+----------+------------+------+----------+---------+
10 rows in set (0.04 sec)
-----------------------------
右关联
-----------------------------
mysql> select user.* ,orders.number from user right join orders on user.id = orders.user_id;
+----+----------+------------+-----+---------+---------+
| id | username | birthday   | sex | address | number  |
+----+----------+------------+-----+---------+---------+
|  1 | 王五     | 2017-11-25 | 3   | 南阳    | 1000010 |
|  1 | 王五     | 2017-11-25 | 3   | 南阳    | 1000011 |
| 10 | 张三     | 2014-07-10 | 1   | 北京市  | 1000012 |
+----+----------+------------+-----+---------+---------+
3 rows in set (0.05 sec)
```

很明显此处错误的选择left会导致查出不必要的数据,可以说是垃圾信息,因为是要查出订单信息(携带用户信息)没有订单的用户就不必要查询出来。

**多级关联查询以及聚合函数的使用**

多级关联和两个表关联查询没什么区别,直接在后面加 **left jion on**

```mysql
mysql> select * from user right join orders on user.id = orders.user_id right join orderdetail on orders.id = orderdetail.orders_id left join items on items.id = orderdetail.items_id;
+----+----------+------------+-----+---------+----+---------+---------+---------------------+------+----+-----------+----------+-----------+----+---------+--------+--------+------------------------------------------+---------------------+
| id | username | birthday   | sex | address | id | user_id | number  | createtime          | note | id | orders_id | items_id | items_num | id | name    | price  | detail | pic                                      | createtime          |
+----+----------+------------+-----+---------+----+---------+---------+---------------------+------+----+-----------+----------+-----------+----+---------+--------+--------+------------------------------------------+---------------------+
|  1 | 王五     | 2017-11-25 | 3   | 南阳    |  3 |       1 | 1000010 | 2015-02-04 13:22:35 | NULL |  1 |         3 |        1 |         1 |  1 | 台式机1 | 3000.0 |        | e2269631-2190-45ed-a215-b8a8dc0dc3d7.png | 2015-02-03 13:22:50 |
|  1 | 王五     | 2017-11-25 | 3   | 南阳    |  3 |       1 | 1000010 | 2015-02-04 13:22:35 | NULL |  2 |         3 |        2 |         3 |  2 | 笔记本  | 6000.0 |        | fffb17d9-0280-461a-b9db-9927ffe5c1b7.png | 2015-02-09 13:22:57 |
|  1 | 王五     | 2017-11-25 | 3   | 南阳    |  4 |       1 | 1000011 | 2015-02-03 13:22:41 | NULL |  3 |         4 |        3 |         4 |  3 | 背包    |  200.0 |        | NULL                                     | 2015-02-06 13:23:02 |
|  1 | 王五     | 2017-11-25 | 3   | 南阳    |  4 |       1 | 1000011 | 2015-02-03 13:22:41 | NULL |  4 |         4 |        2 |         3 |  2 | 笔记本  | 6000.0 |        | fffb17d9-0280-461a-b9db-9927ffe5c1b7.png | 2015-02-09 13:22:57 |
+----+----------+------------+-----+---------+----+---------+---------+---------------------+------+----+-----------+----------+-----------+----+---------+--------+--------+------------------------------------------+---------------------+
4 rows in set (0.08 sec)
```

**复杂的sql**

要求: 统计用户的各订单价格

(注意,这里每个订单中可能有几个订单项,比如一个订单里面有书和鞋,这里面的订单价格就是 书的价格+鞋的价格)

```mysql
mysql> select user.id,user.username,user.address,orders.number,sum(items.price) from user right join orders on user.id = orders.user_id right join orderdetail on orders.id = orderdetail.orders_id left join items on items.id = orderdetail.items_id GROUP BY orders.number;
+----+----------+---------+---------+------------------+
| id | username | address | number  | sum(items.price) |
+----+----------+---------+---------+------------------+
|  1 | 王五     | 南阳    | 1000010 |           9000.0 |
|  1 | 王五     | 南阳    | 1000011 |           6200.0 |
+----+----------+---------+---------+------------------+
2 rows in set (0.11 sec)


mysql> 
select user.id,user.username,user.address,orders.number,items.name, items.price from user right join orders on user.id = orders.user_id right join orderdetail on orders.id = orderdetail.orders_id left join items on items.id = orderdetail.items_id;
+----+----------+---------+---------+---------+--------+
| id | username | address | number  | name    | price  |
+----+----------+---------+---------+---------+--------+
|  1 | 王五     | 南阳    | 1000010 | 台式机1 | 3000.0 |
|  1 | 王五     | 南阳    | 1000010 | 笔记本  | 6000.0 |
|  1 | 王五     | 南阳    | 1000011 | 背包    |  200.0 |
|  1 | 王五     | 南阳    | 1000011 | 笔记本  | 6000.0 |
+----+----------+---------+---------+---------+--------+
4 rows in set (0.08 sec)
```

第一个查询统计价格用到了 sum() 函数 用来累加求和 属于聚合函数

数据聚合函数的还有 avg()求平均值 max()最大值 min()最小值 count()统计数据条数。




批量插入随机数据

```mysql
DELIMITER //
DROP PROCEDURE IF EXISTS test;
CREATE PROCEDURE test()
BEGIN
	DECLARE i INT;
	SET i = 0;
	lp: LOOP
		INSERT INTO roster_worker VALUES (0, 
			ELT(CEILING(rand() * 4), 'Joseph', 'Kaye', 'Linda', 'Baron'),
			ELT(CEILING(rand() * 4), 'WE', 'RNG', 'SKT', 'SSW'),
			NOW()
		);
		SET i = i + 1;
		IF i > 100 THEN
			LEAVE lp; 
		END IF; 
	END LOOP lp;
END
//
DELIMITER ;
CALL test();

```

分页

```mysql
select * from _table limit (page_number-1)*lines_perpage, lines_perpage

或

select * from _table limit lines_perpage offset (page_number-1)*lines_perpage
```