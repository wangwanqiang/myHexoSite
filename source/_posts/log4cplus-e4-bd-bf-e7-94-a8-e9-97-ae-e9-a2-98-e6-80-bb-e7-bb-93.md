title: log4cplus 使用问题总结
id: 197
categories:
  - 未分类
date: 2016-08-16 08:58:21
tags:
---
一个问题浪费两次时间，真是一个悲伤的故事。

问题出在对于按时间归档的 Appender 的理解失误上，在网上找啊找啊，都是千篇一律的抄来抄去，完全不符合要求。明明记得在不久以前处理过这个问题，但却就忘了提交了呢。宝宝心里苦啊。

我这里要求是按时间生成文件名，也就是文件名是按当时的时间去确定的。当是库上的版本却用了 DailyRollingFileAppender 这个。这个的在确的意思是，多长时是一归档，当然归档会有一个文件名的规则。
而这里的问题正确应该用：TimeBasedRollingFileAppender

下面是一个例子：

~~~
log4cplus.appender.OTS_H=log4cplus::TimeBasedRollingFileAppender
log4cplus.appender.OTS_H.MaxHistory=10
log4cplus.appender.OTS_H.FilenamePattern=%d{yyyy-MM-dd-HH-mm}_OTS.csv
log4cplus.appender.OTS_H.layout=log4cplus::PatternLayout

log4cplus.appender.OTS_H.layout.ConversionPattern=%m%n
log4cplus.appender.OTS_H.RollOnClose=false
log4cplus.appender.OTS_H.Schedule=DAILY
log4cplus.appender.OTS_H.CreateDirs=true
~~~