---
title: 解决 package 'fontconfig' not found
categories:
  - linux
  - compile
tags:
  - linux
  - compile
abbrlink: 8e2e
date: 2020-01-20 17:32:18
---

# 解决 package 'fontconfig' not found

Whenever you get messages about missing packages (or suggestions to modify your PKG_CONFIG_PATH) during a build, it usually indicates that you are missing the corresponding development package - which is typically separate from the runtime package that is normally installed on the system.

In this case you have the most recent version of fontconfig but are probably missing the corresponding libfontconfig1-dev package.

正确的解决方法是安装：**libfontconfig1-dev**
