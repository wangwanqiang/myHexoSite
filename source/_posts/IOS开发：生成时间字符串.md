---
title: IOS开发：生成时间字符串
id: 123
categories:
  - IOS 开发
date: 2016-03-01 20:55:48
tags:
---

<span class="s1">//</span><span class="s2">时间标记字符串生成</span>

<span class="s2">-(</span><span class="s3">NSString</span><span class="s2">*)TimeStamp</span>

<span class="s2">{</span>

<span class="s2"><span class="Apple-converted-space">    </span></span><span class="s3">NSDate</span><span class="s2"> *today = [</span><span class="s3">NSDate</span> <span class="s3">date</span><span class="s2">];</span>

<span class="s4"><span class="Apple-converted-space">    </span></span><span class="s2">NSDateFormatter</span><span class="s4"> *dateFormatter = [[</span><span class="s2">NSDateFormatter</span> <span class="s2">alloc</span><span class="s4">]</span><span class="s2">init</span><span class="s4">];</span>

<span class="s2"><span class="Apple-converted-space">    </span>[dateFormatter </span><span class="s3">setDateFormat</span><span class="s2">:</span><span class="s5">@"yyyy-MM-dd hh:mm:ss"</span><span class="s2">];</span>

<span class="s2"><span class="Apple-converted-space">    </span></span><span class="s3">NSString</span><span class="s2"> *strDate = [dateFormatter </span><span class="s3">stringFromDate</span><span class="s2">:today];</span>

<span class="s2"><span class="Apple-converted-space">    </span></span><span class="s3">NSLog</span><span class="s2">(</span><span class="s5">@"Time: %@"</span><span class="s2">,strDate);</span>

<span class="s2"><span class="Apple-converted-space">    </span></span><span class="s6">return</span><span class="s2"> strDate;</span>

<span class="s2">}</span>
