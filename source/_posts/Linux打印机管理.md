---
title: Linux打印机管理
url: 321.html
id: 321
comments: false
date: 2019-04-08 15:03:40
tags:
---

lpq -a //显示出目前所有打印机的工作队列情况 lprm 11 //取消11号打印机作业 lpq -l -P Hp2015 //用详细方式显示打印机Hp2015作业 

lpstat -t ：列出目前的“打印系统”状态，不只包括打印机而已 暂停或者开始打印机： 

重新开始打印机 sudo cupsenable HP\_LaserJet\_1020 

禁用打印机 sudo cupsdisable HP\_LaserJet\_1020
