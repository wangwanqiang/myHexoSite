---
title: linux 命令之：halt 不掉电
url: 106.html
id: 106
date: 2015-07-28 20:12:14
tags:
---

用halt 关机，每次都不断电，后面只能强关。 查了一下 man 手册，发现加个参数就可以了。 sudo halt -p 电源终于一起关了。