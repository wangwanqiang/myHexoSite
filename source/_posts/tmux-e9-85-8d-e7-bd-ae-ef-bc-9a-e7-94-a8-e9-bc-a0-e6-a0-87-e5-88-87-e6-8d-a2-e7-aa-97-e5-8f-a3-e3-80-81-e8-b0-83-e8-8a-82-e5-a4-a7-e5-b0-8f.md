title: tmux配置：用鼠标切换窗口、调节大小
id: 246
categories:
  - linux
date: 2017-04-28 09:16:30
tags:
---
以下内容来自这里：[HERE](http://www.cnblogs.com/bamanzi/p/tmux-mouse-tips.html)

其实就这么几行配置:
~~~
setw -g mouse-resize-pane on
setw -g mouse-select-pane on
setw -g mouse-select-window on
setw -g mode-mouse on
~~~
这几行的作用分别是:
~~~
开启用鼠标拖动调节pane的大小（拖动位置是pane之间的分隔线）
开启用鼠标点击pane来激活该pane
开启用鼠标点击来切换活动window（点击位置是状态栏的窗口名称）
开启window/pane里面的鼠标支持（也即可以用鼠标滚轮回滚显示窗口内容，此时还可以用鼠标选取文本）
~~~
这几行配置加到 ~/.tmux.conf 中，然后在tmux里面按 C-b : 执行 source ~/.tmux.conf 即可生效 （也可以直接将这几行放在 C-b : 的输入行去执行，每次执行一行，不过 tmux重启后还得再来一遍）。