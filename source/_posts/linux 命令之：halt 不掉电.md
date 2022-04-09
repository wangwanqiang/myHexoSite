---
title: linux 命令之：halt 不掉电
id: 106
categories:
  - linux
date: 2015-07-28 20:12:14
tags:
---

用halt 关机，每次都不断电，后面只能强关。

查了一下 man 手册，发现加个参数就可以了。

sudo halt -p 

电源终于一起关了。

#### shutdown 与 halt 的区别

shutdown实际上是调用init 0, init 0会cleanup一些工作然后调用halt或者poweroff。其实主要区别是halt和poweroff，做没有acpi的系统上，halt只是关闭了os，电源还在工作，你得手动取按一下那个按钮，而poweroff会发送一个关闭电源的信号给acpi。

#### 本人HP服务器中自动关机的配置

```
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user	command
17 *	* * *	root    cd / && run-parts --report /etc/cron.hourly
25 6	* * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6	* * 7	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6	1 * *	root	test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
55 23   * * *   root    /sbin/shutdown -h now
15 18   * * *   wwq     /home/wwq/raid/video/qnas_homes_bakup/rsync_from_qnas_homes.sh > ~/rsync_from_qnas_homes.log

```