---
title: linux时区配置
date: 2022-04-10 12:10:16
tags: 
    - linux
categories:
    - linux
---

#### 显示当前系统时区

```
timedatectl
```

#### 显示系统支持的时区列表

```
timedatectl list-timezones
```

#### 设置时区

```
sudo timedatectl set-timezone Asia/Hong_Kong
```