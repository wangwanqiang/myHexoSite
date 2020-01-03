---
title: IOS开发：获取屏幕大小的宏
id: 121
categories:
  - IOS 开发
date: 2016-03-01 20:50:23
tags:
---

<span class="s1">//</span><span class="s2">获取设备屏幕尺寸</span>

<span class="s2">#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)</span>

<span class="s2">#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)</span><span class="s3">//</span><span class="s4">应用尺寸</span>

<span class="s2">#define APP_WIDTH [[UIScreen mainScreen]applicationFrame].size.width</span>

<span class="s2">#define APP_HEIGHT [[UIScreen mainScreen]applicationFrame].size.height</span>