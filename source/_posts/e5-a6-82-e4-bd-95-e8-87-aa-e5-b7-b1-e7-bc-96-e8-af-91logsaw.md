---
title: 如何自己编译Logsaw
id: 233
categories:
  - 日志系统
date: 2017-04-22 09:59:26
tags:
---

Logsaw是一个非常不错的日志分析工具，自已编译一定要严格按照它的编译教程来做。自己花了一些时间，对eclipse不熟悉。

教程的链接：http://logsaw.sourceforge.net/?page_id=260

重点要关注的：eclipse版本选择：the latest version of Eclipse for RCP and RAP Developers.

下载代码，导入工程一般不会有问题。这里就不说了。下面的要注意：

1\. navigate into the releng project, and open the workspace.target file in there. In the Target Definition editor, hit the **Set as Target** Platform button in the upper right corner. 打开releng工程的workspace.target文件，然后点击这一页上面的链接Set as Target,然后要等一会儿，应该是去网上下载东西去了。

2\. right-click on the releng project and choose Run As > Maven build.... In the following dialog, enter the goals **clean package** and then hit run. Run As会出来几个，一定要找那个可以输入goals的，然后输入clean package然Run就可以了。为毛是clean package啊，好迷惑。

3\. 生成的安装在这里：/net.sf.logsaw.site.feature/target/products
