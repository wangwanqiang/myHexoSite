---
title: 如何进入正在运行的Docker容器
url: 216.html
id: 216
date: 2017-04-14 19:10:02
tags:
---

网上有很多种方式，比如ssh什么的。但下面这种方法我认为应该是最好，最方便的。 `$ sudo docker ps $ sudo docker exec -it 775c7c9ee1e1 /bin/bash` 其中775c7c9ee1e1是容器的运行时id。