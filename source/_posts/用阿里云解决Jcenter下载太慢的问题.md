---
title: 用阿里云解决Jcenter下载太慢的问题。
id: 222
categories:
  - 未分类
date: 2017-04-17 22:20:56
tags:
---

**亲测速度，极好。**

使用阿里云的国内镜像仓库地址，修改项目根目录下的文件 build.gradle ：

` 
buildscript {
   repositories {
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
    }
}

allprojects {
    repositories {
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public/'}
    }
}
`

然后选择重新构建项目就可以了