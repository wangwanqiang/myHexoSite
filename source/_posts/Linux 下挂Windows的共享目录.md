---
title: Linux 下挂Windows的共享目录
id: 148
categories:
  - linux
tags:
  - linux
abbrlink: ee8a
date: 2016-03-02 17:41:12
---

mount -t cifs -o username=windowsusername //windows machine/sharefiles /mnt/localfolder

如：
```
sudo mount -t cifs -o username=wwq,password=xxxxxx  //10.2.37.56/Users/wwq/Desktop/work  /mnt/share
```
其中：
```
windowsusername : Windows用户名
windows machine ：Windows机器名
sharefiles ：Windows共享文件夹名
```

然后就可以在 /mnt/localfolder 下访问Windows内容。

注意要先创建目录，这里是 /mnt/share
