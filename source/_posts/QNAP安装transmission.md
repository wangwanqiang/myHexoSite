---
title: QNAP安装Transmission下载工具
url: 366.html
id: 366
comments: false
tags:
  - qnap
  - 下载
  - docker
  - transmission
abbrlink: f9d4
date: 2019-07-16 22:00:06
---

# QNAP安装Transmission下载工具

本文介绍如何在QNAP NAS上通过Docker安装Transmission下载工具，这是一个轻量级的BT下载客户端。

## 前提条件

- QNAP NAS已安装并运行Docker应用
- 已创建用于存放Transmission数据的共享文件夹

## 安装步骤

### 方法一：使用Docker命令行安装

通过SSH登录到QNAP NAS，执行以下Docker命令：

```bash
docker create \
  --name=transmission \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Asia/Shanghai \
  -e TRANSMISSION_WEB_HOME=/combustion-release/ `#可选的Web界面` \
  -p 9091:9091 \
  -p 51413:51413 \
  -p 51413:51413/udp \
  -v /share/homes/docker/trans/data:/config \
  -v /share/homes/docker/trans/downloads:/downloads \
  -v /share/homes/docker/trans/watch:/watch \
  --restart unless-stopped \
  linuxserver/transmission
```

### 方法二：使用QNAP Container Station安装

1. 打开QNAP Container Station
2. 搜索"linuxserver/transmission"
3. 下载并创建容器
4. 在高级设置中配置端口映射和卷映射
5. 设置环境变量
6. 启动容器

## 参数说明

### 环境变量

- **PUID=1000**：用户ID，建议设置为admin用户的ID
- **PGID=1000**：组ID，建议设置为administrators组的ID
- **TZ=Asia/Shanghai**：时区设置，使用中国标准时间
- **TRANSMISSION_WEB_HOME**：可选，自定义Web界面

### 端口映射

- **9091:9091**：Web界面访问端口
- **51413:51413**：BT下载TCP端口
- **51413:51413/udp**：BT下载UDP端口

### 卷映射

- **/share/homes/docker/trans/data:/config**：配置文件存放路径
- **/share/homes/docker/trans/downloads:/downloads**：下载文件保存路径
- **/share/homes/docker/trans/watch:/watch**：监控文件夹，放入此文件夹的种子会自动开始下载

## 访问Transmission

安装完成后，通过以下方式访问Transmission：

1. 打开浏览器，输入`http://QNAP_IP:9091`
2. 首次访问不需要登录密码（建议设置密码）

## 配置说明

### 设置登录密码

1. 进入Web界面
2. 点击右上角设置图标
3. 选择"远程"选项卡
4. 勾选"要求身份验证"
5. 设置用户名和密码
6. 点击"保存设置"

### 配置下载设置

1. 进入Web界面
2. 点击右上角设置图标
3. 选择"下载"选项卡
4. 设置下载文件夹、限速等参数
5. 点击"保存设置"

## 常见问题

### 1. 无法访问Web界面

- 检查容器是否正常运行
- 确认端口映射是否正确
- 检查防火墙设置

### 2. 下载速度慢

- 检查QNAP的网络连接
- 确保端口51413已在路由器上进行端口转发
- 调整Transmission的下载设置

### 3. 权限问题

- 确认PUID和PGID设置正确
- 检查共享文件夹的权限设置

## 提示

- 建议定期备份Transmission的配置文件和种子
- 合理设置上传限速，避免影响其他网络应用
- 使用监控文件夹功能可以方便地管理下载任务
