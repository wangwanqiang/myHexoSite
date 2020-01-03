---
title: Windows远程桌面连接Linux
url: 298.html
id: 298
comments: false
date: 2018-07-11 18:58:04
tags:
---

Windows连接Linux 在Linux装下xrdp软件 `1、安装xrdp sudo apt-get install xrdp 2、配置xrdp /etc/xrdp/xrdp.ini 复制一个配置将其中的port 配置成5900及名称改下， service xrdp restart 3、安装vino sudo apt-get install vino 4、vino-preference 将第1 个开启 5、gsettings set org.gnome.Vino require-encryption false 6、/usr/lib/vino/vino-server/`