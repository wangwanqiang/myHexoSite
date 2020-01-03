---
title: Micro Gen8 sata5 启动 Linux
url: 187.html
id: 187
date: 2016-05-02 10:47:07
tags:
---

经过5+小时的尝试，终于找到了方法。参考了这个文章：http://www.newsmth.net/nForum/#!article/DigiHome/419729 1. 找一张TF卡，我的是2G的。 2. 启动盘准备的时候，我能进到Linux中，但是用grub-install死活也装不好，浪费了好多时间，各种参数。最后没有办法，使用了这个文章准备的grub镜像，直接用win32diskImager写的启动盘。 3. 但这个启动盘能进grub，但不能启动我的系统，我和文章的不一样的，我的sata5位置是我安装好的xunbuntu。 4. 去掉所有的盘，只留一个sata5的系统盘，进入系统。在安装好的系统盘中，找到/boot/grub/grub.cfg，复制这个文件替换掉Tf卡里的这个文件。 5. 重新开机吧，setup里面选择U盘启动。再插其它的硬盘，总会是从sata5启动的。