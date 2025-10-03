---
title: xcode 根据不同的编译目标加载不同的库
id: 174
categories:
  - IOS 开发
abbrlink: f178
date: 2016-03-10 22:05:27
tags:
---

在xcode上开发IOS程序，可以将一个项目编译模拟器和真机，对应着又分别有debug和Release, 相应的别人提供的库也可能按这样给的，代码中要怎么加载呢？

xcode中可以直接配置：

打开工程配置文件，选择 “TARGETS”,找到“Build Settings”选项卡，然后找到“Search Paths”，设置“Library Search Paths”。根据不同的平台选择相应的库的路径就可以了。