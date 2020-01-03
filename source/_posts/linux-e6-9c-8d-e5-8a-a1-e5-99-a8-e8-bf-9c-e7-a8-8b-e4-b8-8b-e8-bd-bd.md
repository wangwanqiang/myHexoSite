---
title: linux 服务器远程下载
id: 109
categories:
  - linux
date: 2015-08-01 18:46:00
tags:
---

**安装 aria2**

sudo apt-get install aria2

这样装好了以后，就可以用 ssh 使用 aria2c 了。

但这样有个问题，下载比较花时间，ssh退出，服务就断开了，怎么解决呢？

**安装 screen**

sudo apt-get install screen

运行时，ssh 后，先 screen ，再在 screen 中 下载，这样就不用怕关 ssh 了。

用 ssh 总是有点不好吧？我不喜欢怎么办？

有个web gui 可以选择。先在服务器上把 aria2 服务跑起来。

<span class="s1">aria2c --enable-rpc --rpc-listen-all=true --rpc-allow-origin-all -c</span>

执行上面的这个就可以了。

下面打开网站：http://aria2c.com/

这个界面的右上有个搬手，点入那个界面，配置好里面的ip，改成服务器ip, 保存。

现在就可以以后在这个网址上，添加下载任务了，当然文件是下载到你的服务器上的。