---
title: Qt设置系统时间
date: 2022-06-13 19:47:48
categories:
  - Qt
tags:
  - Qt
---

```
QString date = "date -s \"2007-08-03 14:15:00\"" 
QProcess::startDetached(date);
QProcess::startDetached("hwclock -w"); // 同步系统时间
QProcess::startDetached("sync"); // 保存配置
```

