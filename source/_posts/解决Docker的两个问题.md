---
title: 解决Docker的两个问题
tags:
  - docker
id: 119
categories:
  - 未分类
date: 2016-02-28 09:01:19
---

解决运行docker 命令一直要用sudo的问题

# 添加docker用户组
$ sudo groupadd docker
# 把自己加到docker用户组中
$ sudo gpasswd -a myusername docker
# 重启docker后台服务
$ sudo service docker restart
# 注销，然后再登陆
$ exit

删除所有运行的docker容器

$ docker rm $(docker ps -a -q)