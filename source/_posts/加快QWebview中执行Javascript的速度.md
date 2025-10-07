---
title: 加快QWebview中执行Javascript的速度
url: 304.html
id: 304
comments: false
abbrlink: 7bc4
date: 2018-08-13 19:37:46
tags:
  - Qt
  - QWebView
  - JavaScript
  - 性能优化
---

## 问题描述

在使用Qt的QWebView执行JavaScript代码时，可能会遇到执行速度非常慢且内存占用过高的问题。这通常发生在执行包含jQuery的代码时。

## 问题原因

经过分析发现，问题的根源在于：Qt会自动评估JavaScript代码最后一条语句的返回值，并将其转换为QVariant对象。当使用jQuery时，jQuery函数通常会返回jQuery对象本身，而Qt会递归地评估整个jQuery对象，这导致了大量的时间和内存消耗。

值得注意的是，之前有些开发者尝试使用`console.log()`来解决这个问题，实际上真正起作用的不是`console.log()`本身，而是它返回的`null`值。

## 解决方案

最简单的解决方案是在JavaScript代码末尾添加`; null`，这样就不会返回复杂的jQuery对象，而是返回一个简单的`null`值，从而避免了Qt对复杂对象的递归评估。

### 示例代码

```cpp
// 优化前
myWebElement->evaluateJavaScript(myScript);

// 优化后
myWebElement->evaluateJavaScript(myScript + "; null");
```

如果您在使用QWebView执行JavaScript时发现速度异常缓慢，请尝试上述方法，通常能显著提高执行效率并降低内存占用。
