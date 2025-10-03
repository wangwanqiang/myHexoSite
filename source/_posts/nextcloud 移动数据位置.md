---
title: nextcloud 移动数据位置
url: 338.html
id: 338
comments: false
abbrlink: 77ce
date: 2019-06-01 20:33:44
tags:
---

下面是官方说明： https://github.com/nextcloud/nextcloud-snap/wiki/Change-data-directory-to-use-another-disk-partition Removable media Also note that the interface providing the ability to access removable media is not automatically connected upon install, so if you'd like to use external storage (or otherwise use a device in /media for data), you need to give the snap permission to access removable media by connecting that interface: $ sudo snap connect nextcloud:removable-media 可以使用 mount --bind 命令挂载已有目录。要实现自动挂载，可以写在 /etc/fstab 里面。