---
title: Win10 微软拼音双拼设置
categories:
  - win10
  - 输入法
tags:
  - win10
  - 输入法
abbrlink: fbb2
date: 2020-06-02 12:34:25
---

# Win10 微软拼音双拼设置

## Win10 微软拼音添加小鹤双拼

首先打开注册表，找到这个路径: 
```
计算机\HKEY_CURRENT_USER\Software\Microsoft\InputMethod\Settings\CHS
```
然后新建一个名为 UserDefinedDoublePinyinScheme0的字符串值，数值数据为

```
小鹤双拼*2*^*iuvdjhcwfg^xmlnpbksqszxkrltvyovt
```

然后在设置中将默认的输入法设置为小鹤双拼。


## 微软拼音支持自定义时间格式

```
# 关键字需要用 %% 来包裹
yyyy    4 位年
MM	    2 位月
dd	    2 位日
HH  	2 位小时（24 小时制）
mm  	2 位分钟数
ss  	2 位秒数
```

示例：

```
# 结果是这样的格式: 2020-02-07 12:36:52
# 具体的格式参看, 详见 ref
%yyyy%-%MM%-%dd% %HH%:%mm%:%ss%
```
