title: IOS获取当前时间并转换成可显示字符串的方法
id: 244
categories:
  - IOS
date: 2017-04-26 22:48:54
tags:
---
本来很简单的时，在IOS上涉及到的东西还挺多。

~~~

*   (NSString *)getCurrentTimeString {
NSDate *today = [NSDate date];
//   NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate: today];
//   NSDate *localeDate = [today  dateByAddingTimeInterval: interval];

    NSDateFormatter _formatter = [[NSDateFormatter alloc] init] ;
[formatter setDateStyle:NSDateFormatterMediumStyle];
[formatter setTimeStyle:NSDateFormatterShortStyle];
[formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; //hh与HH的区别:分别表示12小时制,24小时制
//设置时区,这个对于时间的处理有时很重要
//NSTimeZone_ timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
NSTimeZone* timeZone = [NSTimeZone systemTimeZone];

    [formatter setTimeZone:timeZone];

    //NSString * date_str = [localeDate description];
NSString * date_str = [formatter stringFromDate:today];
return date_str;
}
~~~
