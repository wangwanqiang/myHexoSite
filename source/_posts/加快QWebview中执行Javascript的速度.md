---
title: 加快QWebview中执行Javascript的速度
url: 304.html
id: 304
comments: false
date: 2018-08-13 19:37:46
tags:
---

The issue is that Qt is evaluating the return value of the last statement in Javascript and converting it to a QVariant. It became time consuming because jQuery was returning the jQuery object, which was being evaluated in its entirety by Qt - and recursively at that. This also consumed RAM too. It wasn't console.log that was fixing the issue, it was the "null" value it returned. I tested, and stapling "null" at the end of the script also worked. 

Below is the updated code. 

```
myWebElement->evaluateJavaScript( myScript + "; null" ); 
```

如果发现执行速度超级慢，按上面的方法处理。
