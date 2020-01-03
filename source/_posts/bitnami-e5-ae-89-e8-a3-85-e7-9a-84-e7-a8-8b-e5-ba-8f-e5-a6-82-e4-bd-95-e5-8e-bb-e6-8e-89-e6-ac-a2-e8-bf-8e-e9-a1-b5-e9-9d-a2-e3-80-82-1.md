---
title: bitnami安装的程序如何去掉欢迎页面。
url: 206.html
id: 206
date: 2016-10-19 19:31:48
tags:
---

就是网址打开的那个页面。去掉它直接进入安装的程序。 方法如下：

1.  在开始菜单找到安装程序的命令行的窗口。执行。
2.  cd 命令进入到 apps 目录下面的程序的目录下：比如我这个：D:\\Bitnami\\redmine-3.3.1-0\\apps\\redmine>
3.  执行这个目录下面的 bnconfig.exe 程序，参数像这样： bnconfig.exe --appurl /

然后再到开始菜单中去重启整个服务。 我用的是Windows版，别的应该也是一样的。