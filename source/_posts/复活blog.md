---
title: blog复活
date: 2020-01-04 16:14:16
tags:
    - hexo
    - next
    - blog
---

# 回顾

之前在阿里云上花钱买了一个网页空间，用了好几年，刚开始还挺好的，但最近半年，完全不能用。频繁刷新都能被关黑屋。还遇到有人恶意访问。

今天终于花时间弄清楚了 github + hexo + next + travis-ci 的blog组合。

搞清楚了hexo 的 tags 和 categories 的启用方法。

从目前的情况来说，与之前的 wordpress 对比，显示完美，当然写作没有之前的方便。

还支持 https，并且 github 技术加持，不担心被人恶意黑掉。自己的域名也能完美支持。

总之，blog 重新复活。

# 如何快速创建一个github个人网站？

克隆一个已经存在的网站:)，比如我这个[网站](https://github.com/wangwanqiang/myHexoSite.git)。然后把source目录中的内容删除掉。在调整一下自己的配置就可以了。

# hexo blog 如何创建404页面

有两种方法：

1. 可以自己创建一个 404.html 页面直接放到 source 目录下面。

2. 也可以在 source 目录下面创建一个 404 的文件夹， 然后面在里面创建一个 index.md 的文件。 可以使用这个命令创建 ` hexo new page "404" `

