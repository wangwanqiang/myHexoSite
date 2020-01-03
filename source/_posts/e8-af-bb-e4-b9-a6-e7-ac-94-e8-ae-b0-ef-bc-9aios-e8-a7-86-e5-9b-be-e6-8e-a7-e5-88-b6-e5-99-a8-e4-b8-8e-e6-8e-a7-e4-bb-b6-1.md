---
title: 读书笔记：IOS视图控制器与控件
url: 36.html
id: 36
date: 2015-05-19 05:55:16
tags:
---

\# IOS 视图控制器 ## 视图控制器之间的切换 在响应的位置，创建需要的视图控制器，然后preset过去。 ## 视图控制器之间传递数据 1. 通知中心 最简单的方式，缺点就是两个类之前没有关系。 1. 代理模式 采用协议的方式，需要向外传数据的类定义代理，接受数据的类实现协议。协议赋值采用 assign。 # IOS 控件 * UILabel * UIControl 处理事件 * UIButton 处理状态 工厂方法：buttonWithType 贴图的方法，要使用custorm Type cancel 事件，来电话和锁屏触发 * 风火轮（UIActivityIndicatorView） 显示与停止，显示到状态栏。