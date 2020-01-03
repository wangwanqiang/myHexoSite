---
title: Thinkpad 小红点恢复Win10中键滚动功能
url: 385.html
id: 385
categories:
  - 未分类
date: 2019-12-21 21:41:02
tags:
---

问题
==

在Windows 10下面，按住中键，拔动小红点，页面滚动的同时，光标也会一起跑。控制面板中也找不到设置的地方。

解决方案
====

需要修改注册表：

在HKEY\_CURRENT\_USER\\Software\\Synaptics\\SynTPEnh\\UltraNavPS2中，把TrackPointModeFunction的值修改一下即可。

原为："TrackPointModeFunction"=dword:00000011

改为："TrackPointModeFunction"=dword:00000010

这样就跟以前使用完全相同了，中键点击是小手或指针，滚动是鼠标中键滚动的图标，一切完美。