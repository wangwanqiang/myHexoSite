---
title: Git基本使用（1）
id: 161
categories:
  - git
tags:
  - git
abbrlink: d007
date: 2016-03-08 08:27:10
---

# Git 基础使用

结合这两天的基本使用情况，进行总结：

## 创建分支

    $ git checkout -b dev # 创建并切换

    `</pre>

    这样就创建了一个名字叫着 dev 的分支。

    注意到这里的 checkout 命令名，他和切换分支是一个命令，只不带了一个 b 参数。

    ## 切换分支

    <pre>`$ git checkout dev  # 切换

    `</pre>

    不带参数，这就是切换到了dev分支。

    ## 合并分支

    <pre>`$ git merge dev # 从dev分支合并

    `</pre>

    把dev分支的修改合并到当前的分支

    ## 查看分支

    <pre>`$ git branch

    `</pre>

    如果你安装了 oh-my-zsh的git支持的话，查看分支其实很少用，补全太强大了，在需要查看分支的地方，可以临时补全显示出来，选择需要操作。

    ## 版本回退

*   回退版本

    <pre>`$ git reset --hard HEAD^     #回滚上一个版本

    $ git reset --hard HEAD^^    #回滚上上一个版本

    $ git reset --hard HEAD~100  #回滚上100个版本

    `</pre>

    这里和SVN的更新到某个版本不一样，svn这时你去看log,自己确实处理中间的某一个版本，而在Git上，此时 Git log，最上面的版本就是回退后的版本。

    ## 撤消版本回退

    回到未来的版本可以用下面的命令：

    <pre>`$ git reset --hard 3628164

后面的数字是Git的版本号，可以使用 git log, git reflog 去找这个版本号，也可以从 gitlab, github这样的服务器上去取，当然你要是从这些服务器上 clone 过来。
