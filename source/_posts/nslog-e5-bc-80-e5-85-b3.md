---
title: NSLog 开关
id: 65
categories:
  - IOS 开发
date: 2015-05-24 14:42:36
tags:
---

开发IOS应用在发布的时候需要将全部的NSLog中去掉，怎么弄呢？可以使用一个宏来控制：

在系统包含的公共头文件中加入下面的语句：

`
#ifndef __OPTIMIZE__
# define NSLog(...) NSLog(__VA_ARGS__)
#else
# define NSLog(...) {}
#endif
`

一般情况下，Release版本系统会定义 __OPTIMIZE__ 宏，而Debug版本不会，根据这个差别使用不同的NSLog，从而达到上面的目的。