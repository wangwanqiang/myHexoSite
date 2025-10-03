---
title: Linux软raid恢复后md127问题
id: 189
categories:
  - linux
  - MicroGen8
tags:
  - linux
  - MicroGen8
abbrlink: 4bd9
date: 2016-05-02 15:28:07
---

1.  检查/etc/mdadm/mdadm.conf，内容是对的，但重启后，还是md127.
2.  在网上看到这个：

查看md0的UUID：
sudo mdadm --detail /dev/md0
拷贝下来UUID 7f59975e:9e637932:dce17021:f68cb000
然后：sudo vim /etc/mdadm/mdadm.conf
在文件的靠前位置，加入这一行：
ARRAY /dev/md0 UUID=7f59975e:9e637932:dce17021:f68cb000
:wq!强制保存后退出vim，下一步很重要！You need to update initramfs so it contains your mdadm.conf settings during boot.
**sudo update-initramfs -u**
否则，重启系统，mdadm会自动将raid1生成/dev/md127，而不是/dev/md0。

update-initramfs 后，确实管用。
