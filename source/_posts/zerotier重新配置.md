---
title: zerotier重新配置
tags: 服务器
date: 2022-04-08 7:20:08
---

#### ubuntu 重新加入已有网络

总共三步：

1. 安装： curl -s https://install.zerotier.com | sudo bash
2. 加入网络： sudo zerotier-cli join 你的network ID
3. 最后一步一定不要忘，要去官网上授权：点击网络id，向下找到授权的部分，在前面打上勾。


