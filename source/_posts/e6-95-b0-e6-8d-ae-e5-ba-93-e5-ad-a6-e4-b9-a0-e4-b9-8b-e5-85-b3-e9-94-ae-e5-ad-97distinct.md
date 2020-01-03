title: 数据库学习之关键字DISTINCT
id: 231
categories:
  - 未分类
date: 2017-04-21 07:07:25
tags:
---
如果一列的值有多个，查询的时间，这些值是会多次返回的。如果不在乎次数，只在有没有。也就是出现过了就不要再出现了，要实现这样的查询就要用到DISTINCT关键字。
其用法如下：
~~~
SELECT **DISTINCT** vend_ id FROM Products;
~~~
[美]Ben Forta. SQL必知必会（第4版） (图灵程序设计丛书 80) (Kindle Location 325). 人民邮电出版社. Kindle Edition.