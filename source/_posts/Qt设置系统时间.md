---
title: Qt����ϵͳʱ��
categories:
  - Qt
tags:
  - Qt
---

```
QString date = "date -s \"2007-08-03 14:15:00\"" 
?QProcess::startDetached(date);
?QProcess::startDetached("hwclock -w"); // ͬ��ϵͳʱ��
?QProcess::startDetached("sync"); // ��������
```
