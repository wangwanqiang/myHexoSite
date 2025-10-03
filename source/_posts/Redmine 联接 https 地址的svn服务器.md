---
title: Redmine 联接 https 地址的svn服务器
url: 295.html
id: 295
comments: false
abbrlink: 80f1
date: 2018-06-23 12:22:45
tags:
---

https://blog.csdn.net/taonull/article/details/39249729 1.打开redmine控制台； 2.运行svn list --xml https://svn地址； 3.提示证书时选择p（永久保存ssl凭证）； 4.运行成功后，找到subversion\_adapter.rb(redmine文件夹\\apps\\redmine\\htdocs\\lib\\redmine\\scm\\adapters)，找到 def credentials\_string `str << " --username #{shell_quote(@login)}" unless @login.blank? str << " --password #{shell_quote(@password)}" unless @login.blank? || @password.blank? str << " --no-auth-cache --non-interactive"` 修改为： `str << " --username #{shell_quote(@login)}" unless @login.blank? str << " --password #{shell_quote(@password)}" unless @login.blank? || @password.blank? str << " --trust-server-cert --no-auth-cache --non-interactive --config-dir \"c:/Users/Administrator/AppData/Roaming/Subversion\""`