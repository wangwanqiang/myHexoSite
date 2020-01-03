---
title: Qt Creator选择 run in terminal后不能启动程序的问题
id: 194
categories:
  - linux
date: 2016-06-16 13:48:59
tags:
---

升级4.X以后，出现这个问题，一直卡在加载程序的地方，取消掉这个选项就没有问题。
解决的方法是：不要使用默认的终端程序，使用 xterm

Under Tools-Options-Environment-General, change the terminal value from x-terminal-emulator -e to  /usr/bin/xterm -e.