---
title: IOS设置固定大小的图片
url: 268.html
id: 268
date: 2018-01-20 12:21:19
tags:
---

`固定图片大小

    UIImage * img = [UIImage imageNamed:@"doorlogo"];
    
    CGSize itemSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [img drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();`