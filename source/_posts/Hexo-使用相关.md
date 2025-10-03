---
title: Hexo 使用相关
author: Wanqiang
tags:
  - blog
categories:
  - tools
abbrlink: e0b6
date: 2017-11-04 19:36:00
---
# 安装与配置

据说每个从wordpress转过来blog都会有篇文章，这个就是。

## windows

### 两个前提和条件
1. 首先要安装 Node.js 
2. 当然了还要安装 git

### 然后在Windows命令行输入

1. 安装hexo  
~~~
npm install -g hexo
~~~
2. 初始化一个blog，这里名字就叫 hexo
~~~
hexo init hexo
~~~
3. 进入hexo目录
~~~
 cd hexo
~~~
4. 安装依赖文件
~~~
npm install
~~~

5. 部署形成文件
~~~
hexo generate
~~~


## mac

还没有测试过如何弄。

## linux

还没有测试过如何弄。

# 发布

## 本地预览

~~~
hexo s
~~~
就能打开一个本地服务器，通过提示的地址可以看效果。

## 怎么发布到Github的空间中去

首先得有github帐号，肯定有了，不说了。还有就是要在本机配置好如何能push到github上去。github官方有说明，windows还有点复杂，这里暂时不说了。

# 如何写文章

## Draft

在文件夹的source目录下面有个_drafts目录，这里面都是没有Post。

## publish
在文件夹的source目录下面有个_post目录。这里面都是已经post了的。

# 插件
要工作，有些插件必须要有。
1. 发布到github上需要一个插件。
2. 把wordpress内容导入到hexo也需要一个插件。
3. 有个hexo admin的插件可以成倍的减少用hexo的难度。（我正在用）

# 使用心得

next主题很不错，要另外安装。默认的比较丑。