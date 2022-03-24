---
title: win10 打不开samba文件夹的解决方法
id: 202
categories:
  - win10
date: 2016-10-02 09:37:30
tags:
---

Win10 打不开局域网电脑共享的文件夹。

在网上搜了一下，说关掉Pin的，也有说不要用微软帐户的。我试了一下，只关掉PIN是不行的，但不能用指纹登陆了。关掉微软帐户，启用本地帐户，重启就可以。

也有说关掉自动同步，可以用微软帐户的，试了下，应该是不行的。

难道要访问局域网中的资源，只能用本地帐户？ 我想微软应该不会这么傻X吧。肯定是哪里没有设置好。

把设置找了一遍，果然找到了：

Control Panel\Network and Internet\Network and Sharing Centre\Advanced sharing settings

下面的 File and Printer share 默认是关闭的。打开以后就可以了。

这个应该才是正确的解锁姿势，默认是关闭的，默认是关闭的，默认是关闭的。晕倒。