---
title: linux  ssh执行命令断开ssh，命令不退出的方法
id: 103
categories:
  - linux
  - 树莓派
date: 2015-07-19 14:16:08
tags:
  - ssh
  - linux
---

在树莓派上用ssh的 sox 命令行播放音乐，但是，退出ssh后，随着会话的关闭，播放也就停止了。在网上查找了下解决方法：

经测试，都是可以用的。

1\. nohup 

用法：nohup play *.mp3

这样就可以了。

2\. screen

这个在我的树莓派上要按装： apt-get install screen

用法：

先screen,  然后回车。执行自己的命令，我的是 play *.mp3

就可以关掉会话。

使用screen还要以重新打开这个会话：screen -r 

很强大，详情可以 man .
