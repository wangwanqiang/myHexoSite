---
title: mac下登陆ssh报错解决
id: 159
categories:
  - Mac 使用
date: 2016-03-06 09:05:00
tags:
---

mac登陆服务器，不能成功，报下面的错误：

Could not resolve hostname xxxxx.com:9527: nodename nor servname provided, or not known

但是如果在局域网内有没有问题，检查了下自己的输入的命令：

    ssh xxx@xxxxx.com:9527
    

    会出现问题，如果是这样，就可以：

    ssh xxx@192.168.1.5

    就可以

    ### 怎么处理呢？

    能过查找发现，要解决这个问题，命令换个写法就可以了：

    ssh -p 22221 xxx@xxxxx.com

就可以了。

### 但又是什么原因呢？

个人猜测，应该是，mac的ssh程序解析域名的时候，识别不出后面的端口，有bug，同样的做法，用别的ssh客户端就可以了。
