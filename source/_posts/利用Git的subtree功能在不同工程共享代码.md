---
title: 'Git: 利用Git的subtree功能在不同工程共享代码'
id: 156
categories:
  - git
tags:
  - git
abbrlink: 278d
date: 2016-03-05 10:26:27
---

## 1\. 第一次添加子目录，建立与git项目的关联

建立关联总共有2条命令。

语法： git remote add -f &lt;子仓库名> &lt;子仓库地址>

解释：其中-f意思是在添加远程仓库之后，立即执行fetch。

语法： git subtree add --prefix=&lt;子目录名> &lt;子仓库名> &lt;分支> --squash

解释：–squash意思是把subtree的改动合并成一次commit，这样就不用拉取子项目完整的历史记录。–prefix之后的=等号也可以用空格。

示例

    $git remote add -f ai https://github.com/aoxu/ai.git  
    $git subtree add --prefix=ai ai master --squash
    `</pre>

    ## 2\. 从远程仓库更新子目录

    更新子目录有2条命令。

    语法： git fetch &lt;远程仓库名> &lt;分支>

    语法： git subtree pull --prefix=&lt;子目录名> &lt;远程分支> &lt;分支> --squash

    示例

    <pre>`$git fetch ai master  
    $git subtree pull --prefix=ai ai --squash
    `</pre>

    ## 3\. 从子目录push到远程仓库（确认你有写权限）

    推送子目录的变更有1条命令。

    语法： git subtree push --prefix=&lt;子目录名> &lt;远程分支名> 分支

    示例

    <pre>`$git subtree push --prefix=ai ai master
    
