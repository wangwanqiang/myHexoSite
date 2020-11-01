---
title: 树莓派docker运行报错
url: 347.html
id: 347
comments: false
date: 2019-06-07 08:54:02
tags:
---

解决方案
====

This is because the docker service is not automatically started after an install. You can start the docker service in Ubuntu and its derivatives (looking at you Linux Mint) by typing: sudo service docker start To check that docker started, this file should exist: ls -la /var/run/docker.sock