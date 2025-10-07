---
title: Python 2 与 Python 3 共存方案
url: 334.html
id: 334
comments: false
abbrlink: fedb
date: 2019-05-22 09:28:52
tags:
  - Python
  - 环境配置
---

# Python 2 与 Python 3 共存方案

在许多开发环境中，可能需要同时使用 Python 2 和 Python 3 两个版本。以下是实现两个版本共存的详细步骤：

## 安装步骤

1. **下载安装包**：分别下载 Python 2 和 Python 3 的安装包
2. **正常安装**：按顺序安装 Python 2 和 Python 3
3. **配置环境变量**：将两个版本的安装路径和 Scripts 目录添加到系统环境变量中
   - 例如 Python 2 的路径：`C:\Python27` 和 `C:\Python27\Scripts`
   - Python 3 的路径：`C:\Python3x` 和 `C:\Python3x\Scripts`

## 修改解释器名称

为了区分两个版本的 Python 解释器，可以修改可执行文件的名称：

1. 进入 Python 2 的安装目录
2. 将 `python.exe` 重命名为 `python2.exe`
3. 将 `pythonw.exe` 重命名为 `pythonw2.exe`
4. 同样地，对 Python 3 进行类似操作：
   - 将 `python.exe` 重命名为 `python3.exe`
   - 将 `pythonw.exe` 重命名为 `pythonw3.exe`

## 验证安装

在命令行中输入以下命令验证安装是否成功：

```bash
# 检查 Python 2 版本
python2 --version

# 检查 Python 3 版本
python3 --version
```

## pip 的使用

pip 也需要区分版本：

```bash
# 使用 Python 2 的 pip
python2 -m pip install 包名

# 使用 Python 3 的 pip
python3 -m pip install 包名
```

## 编写兼容两个版本的代码

如果需要编写同时兼容 Python 2 和 Python 3 的代码，可以使用以下工具：

### 1. __future__ 模块

```python
# 使用 Python 3 的 print 函数
from __future__ import print_function

# 使用 Python 3 的除法行为
from __future__ import division

# 使用 Python 3 的 Unicode 字符串
from __future__ import unicode_literals
```

### 2. six 库

six 是一个专门用于解决 Python 2 和 Python 3 兼容性问题的库：

```bash
# 安装 six
pip install six
```

使用示例：

```python
import six

if six.PY2:
    print("这是 Python 2")
else:
    print("这是 Python 3")

# 在两个版本中都能正常工作的代码
text = six.u("Unicode 字符串")
```

## 官方文档

有关更多详细信息，请参考官方文档：

- Python 3 安装指南：https://docs.python.org/3/installing/
- six 库官方文档：https://six.readthedocs.io/

通过以上方法，您可以在同一台计算机上无缝地使用 Python 2 和 Python 3，满足不同项目的需求。
