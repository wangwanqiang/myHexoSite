---
title: Qt对话框窗口设置
categories:
  - qt
  - c++
date: 2016-05-02 15:28:07
tags:
  - qt
---

# 设置窗口标题

```
setWindowTitle("Touch Screen"); 
```

# 设置窗口固定大小

```
setFixedSize(QT_WINDOW_WIDTH_FOR_TOUCH, QT_WINDOW_HEIGHT_FOR_TOUCH);
```

# 设置窗口显示在另外一个显示器上

```
QDesktopWidget* desktop = QApplication::desktop();
setGeometry(desktop->screenGeometry(1));
```
