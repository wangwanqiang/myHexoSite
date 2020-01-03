---
title: 头文件及keil C的一点经验(转)
id: 55
categories:
  - 百度空间的旧文章
date: 2015-05-19 06:58:18
tags:
---

<div class="pcs-article-box_ptkaiapt4bxy_baiduscarticle">

# [头文件及keil C的一点经验](http://hi.baidu.com/fc/editor/fckeditor.html?InstanceName=spBlogText&amp;v=3.1&amp;Toolbar=Default&amp;v=3.1.html#)·

<div class="pcs-article-c_ptkaiapt4bxy_baiduscarticle">
<div class="pcs-article-content_ptkaiapt4bxy_baiduscarticle"></div>
<div class="pcs-article-content_ptkaiapt4bxy_baiduscarticle">许多初学者使用网上下载的程序时都会遇到这样一个问题，就是头文件找不到。我想就这个问题说明一下。/
·首先，我们用到的KEIL有几种版本的，头文件也不同。有reg51.h和at89x51.h两种比较常见。at89x51和reg51这两个文件有点不同，reg51没有对IO口的位地址进行定义。所以我们在使用reg51的时候，可能会有一些相关语句通不过，比方说P0_1=1;这样的位操作。
文件都放在Keil的KEILC\C51\INC目录下，大家可以看看自己的KEIL版本使用了哪个头文件，也有些KEIL封装了reg51和at89x51两个头文件，都可以用。/
·头文件定义在程序的第一行，方法是#include ，如果提示这个文件找不到可以改为#include 试试。
·下面是一些使用心得，网上的.使用Keil C调试某系统时积累的一些经验

1、在Windows2000下面，我们可以把字体设置为Courier，这样就可以显示正常。
2、当使用有片外内存的MCU（如W77E58，它有1K片外内存）的时候，肯定要设置标志位，并且编译方式要选择大模式，否则会出错。
3、当使用Keil C跟踪程序运行状态的时候，要把引起Warning的语句屏蔽，否则有可能跟踪语句的时候会出错。
4、在调用数组的时候，Keil C是首先把数组Load进内存。如果要在C中使用长数组的时候，我们可以使用code关键字，这样就实现了汇编的DB的功能，Keil C是不会把标志code的数组Load入内存的，它会直接读取Rom。
5、拉高管脚的执行速度远远比检查管脚电平的要快。当编程涉及到有关通信，时序是很重要的。
6、在等待管脚电平变化的时候，我们需要设置好超时处理，否则程序就会因为一个没有预计的错误而死锁。
7、能用C语言实现的地方，尽量不要用汇编，尤其在算法的实现，用汇编是晦涩难懂。
8、程序的几个参数数组所占篇幅很大，其中液晶背景数组最长，有四千个Byte，因而把那些初始化数组都放在另外一个C文件，在主文件使用使用关键字extern定义，这样就不会对主文件的编写造成干扰。
9、所有函数之间的相关性越低越有利于以后功能的扩展。
10、6.20版在编译带code关键字的数组时，编译通过但是单片机运行结果是错误的，改用6.14版后正常。

</div>
</div>
</div>
<div id="detailArticleFooter_ptkaiapt4bxy_baiduscarticle" class="footer">
<div class="time-cang">收藏于 2009-09-27</div>
<div class="link-src">来自于百度空间</div>
</div>