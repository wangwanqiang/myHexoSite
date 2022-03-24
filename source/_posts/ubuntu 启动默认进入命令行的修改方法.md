---
title: ubuntu 启动默认进入命令行的修改方法
id: 116
categories:
  - linux
date: 2015-09-02 22:10:16
tags:
  - ubuntu
  - linux
---

首先，编辑sudo vi /etc/default/grub 文件，找到如下行:

GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

将其注释掉（待恢复时可用）

#GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"

然后，添加以下内容

GRUB_CMDLINE_LINUX_DEFAULT="text"

保存文件并退出

最后，使用 sudo update-grub 命令，使配置生效

reboot 启动系统即可。
