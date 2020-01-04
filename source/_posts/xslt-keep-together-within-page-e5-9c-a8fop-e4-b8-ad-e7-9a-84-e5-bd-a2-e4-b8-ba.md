---
title: xslt keep-together.within-page 在Fop中的形为
url: 356.html
id: 356
comments: false
date: 2019-07-16 08:59:28
tags:
---
```
keep-together.within-page
```
1.  auto是默认形为, 写不写都是一样的。


2.  always是强制在一页中。如果当前限制的内容超过一页时，会从页面下方溢出。


3.  指定一个数字。测试 1 的形为是这样的：会换页将当前内容保持在一页中。但如果当前内容超过一页时，也会将多余的内容显示到下一页中，保证不会将内容溢出到纸的外面。



https://www.w3.org/TR/xsl11/#keep-together