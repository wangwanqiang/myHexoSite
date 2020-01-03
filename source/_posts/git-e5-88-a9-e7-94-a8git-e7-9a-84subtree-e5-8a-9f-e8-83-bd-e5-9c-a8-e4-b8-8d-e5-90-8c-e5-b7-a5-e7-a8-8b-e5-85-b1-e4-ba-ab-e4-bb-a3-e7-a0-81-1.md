---
title: 'Git: 利用Git的subtree功能在不同工程共享代码'
url: 156.html
id: 156
date: 2016-03-05 10:26:27
tags:
---

1\. 第一次添加子目录，建立与git项目的关联
------------------------

建立关联总共有2条命令。 语法： git remote add -f <子仓库名> <子仓库地址> 解释：其中-f意思是在添加远程仓库之后，立即执行fetch。 语法： git subtree add --prefix=<子目录名> <子仓库名> <分支> --squash 解释：–squash意思是把subtree的改动合并成一次commit，这样就不用拉取子项目完整的历史记录。–prefix之后的=等号也可以用空格。 示例

    $git remote add -f ai https://github.com/aoxu/ai.git  
    $git subtree add --prefix=ai ai master --squash
    

2\. 从远程仓库更新子目录
--------------

更新子目录有2条命令。 语法： git fetch <远程仓库名> <分支> 语法： git subtree pull --prefix=<子目录名> <远程分支> <分支> --squash 示例

    $git fetch ai master  
    $git subtree pull --prefix=ai ai --squash
    

3\. 从子目录push到远程仓库（确认你有写权限）
--------------------------

推送子目录的变更有1条命令。 语法： git subtree push --prefix=<子目录名> <远程分支名> 分支 示例

    $git subtree push --prefix=ai ai master