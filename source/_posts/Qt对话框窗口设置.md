---
title: Qt对话框窗口设置
categories:
  - qt
  - c++
tags:
  - qt
abbrlink: 2de4
date: 2020-01-21 09:28:41
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
if (desktop->screenCount() > 1)
{
   setGeometry(desktop->screenGeometry(1));
}
```

# 在非主线程更新显示

```
QMetaObject::invokeMethod(this, "asyncUpdateGui", Qt::QueuedConnection);
```

其中 asyncUpdateGui 的定义：

```
private slots:
    Q_INVOKABLE void asyncUpdateGui();   
```

实现：

```
void xApplicationWindow::asyncUpdateGui()
{
    update();
}
```



