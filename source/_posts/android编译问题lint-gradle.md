---
title: 'Android 编译问题：Could not find com.android.tools.lint:lint-gradle:26.1.2.'
url: 284.html
id: 284
date: 2018-04-30 10:35:31
tags:
  - android
---

编译时报如下的错误：

```
FAILURE: Build failed with an exception. * What went wrong: Execution failed for task ':app:lintVitalRelease'. > Could not resolve all files for configuration ':app:lintClassPath'. > Could not find com.android.tools.lint:lint-gradle:26.1.2. Searched in the following locations: file:/C:/Users/wwq/AppData/Local/Android/sdk/extras/m2repository/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.pom file:/C:/Users/wwq/AppData/Local/Android/sdk/extras/m2repository/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.jar file:/C:/Users/wwq/AppData/Local/Android/sdk/extras/google/m2repository/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.pom file:/C:/Users/wwq/AppData/Local/Android/sdk/extras/google/m2repository/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.jar file:/C:/Users/wwq/AppData/Local/Android/sdk/extras/android/m2repository/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.pom file:/C:/Users/wwq/AppData/Local/Android/sdk/extras/android/m2repository/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.jar https://jcenter.bintray.com/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.pom https://jcenter.bintray.com/com/android/tools/lint/lint-gradle/26.1.2/lint-gradle-26.1.2.jar Required by: project :app

```

解决方法： 检查根 build.gradle 文件。

```
allprojects { repositories { jcenter() // mavenCentral() google() //**要加这行** // maven { url 'https://jitpack.io' } } }
```
