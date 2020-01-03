---
title: QNAP安装transmission
url: 366.html
id: 366
comments: false
date: 2019-07-16 22:00:06
tags:
---

docker create \ --name=transmission \ -e PUID=1000 \ -e PGID=1000 \ -e TZ=Europe/London \ -e TRANSMISSION\_WEB\_HOME=/combustion-release/ `#optional` \ -p 9091:9091 \ -p 51413:51413 \ -p 51413:51413/udp \ -v /share/homes/docker/trans/data:/config \ -v /share/homes/docker/trans/downloads:/downloads \ -v /share/homes/docker/trans/watch:/watch \ --restart unless-stopped \ linuxserver/transmission