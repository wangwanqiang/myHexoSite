---
title: QMenu 自定义样式
categories:
  - Qt
  - GUI
date: 2020-11-21 08:18:25
tags:
  - Qt
  - GUI
---

通过QSS 去掉菜单前面的对勾。用颜色表示 checked 状态。

```Qss


 QMenu::item {
     padding:8px 32px;/*设置菜单项文字上下和左右的内边距，效果就是菜单中的条目左右上下有了间隔*/
     margin:0px 8px;/*设置菜单项的外边距*/
     border-bottom:1px solid #DBDBDB;/*为菜单项之间添加横线间隔*/
     padding-left:0px;
 }

 QMenu::item:selected { /* when user selects item using mouse or keyboard */
     background-color: #00fff9;/*这一句是设置菜单项鼠标经过选中的样式*/
 }

QMenu::item:checked { /* checked */
    background-color: #ff0000;
}

QMenu::indicator { /* delete the default icon v */
    image: none;
}

```
