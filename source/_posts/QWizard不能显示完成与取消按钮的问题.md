---
title: QWizard不能显示完成与取消按钮的问题
url: 301.html
id: 301
comments: false
date: 2018-08-10 18:48:49
tags:
---

我使用的是Qt5.4.2, 遇到这个问题。对话框显示出来后，用鼠标改变一下大小就能显示出来。看起来像Qt的bug。 经反复尝试，发现修改QWizard的属性styleSheet为ClassicStyle就可以解决这个问题。 具体原因不清楚。
