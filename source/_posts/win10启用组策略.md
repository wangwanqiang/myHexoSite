---
title: Win10 启用组策略
categories:
  - win10
tags:
  - win10
abbrlink: ad08
date: 2020-11-01 16:48:25
---


# Win10 启用组策略

WIN+R 运行输入 gpedit.msc 发现找不到这个命令。在网上查了一下，说可能是因为自已用的Win10是家庭版，不支持这个功能。

发现用下面的方法可以手动安装。亲测好用。

```powershell

@echo off

pushd "%~dp0"

dir /b %systemroot%\Windows\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientExtensions-Package~3*.mum >gp.txt

dir /b  %systemroot%\servicing\Packages\Microsoft-Windows-GroupPolicy-ClientTools-Package~3*.mum >>gp.txt

for /f %%i in ('findstr /i . gp.txt 2^>nul') do dism /online /norestart /add-package:"%systemroot%\servicing\Packages\%%i"

pause

```

把上面的内容存到一个bat文件中。用管理员权限执行，就能自动安装。

然后就可以运行 gpedit.msc 了。
