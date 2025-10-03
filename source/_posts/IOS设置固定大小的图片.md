---
title: IOS设置固定大小的图片
author: Wanqiang
abbrlink: 5fbb
date: 2018-02-17 11:50:54
tags:
---

下面是实现这部分功能的代码：

```
UIImage * img = [UIImage imageNamed:@"doorlogo"];

CGSize itemSize = CGSizeMake(60, 60);
UIGraphicsBeginImageContext(itemSize);
CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
[img drawInRect:imageRect];
cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();
```