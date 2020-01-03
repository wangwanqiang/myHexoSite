---
title: 解决Docker的两个问题
url: 119.html
id: 119
date: 2016-02-28 09:01:19
tags:
---

解决运行docker 命令一直要用sudo的问题 # 添加docker用户组 $ sudo groupadd docker # 把自己加到docker用户组中 $ sudo gpasswd -a myusername docker # 重启docker后台服务 $ sudo service docker restart # 注销，然后再登陆 $ exit 删除所有运行的docker容器 $ docker rm $(docker ps -a -q)