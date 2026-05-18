---
title: 如何进入正在运行的Docker容器
id: 216
categories:
  - docker
  - 容器技术
abbrlink: '7007'
date: 2017-04-14 19:10:02
comments: true
tags:
  - Docker
  - 容器
  - 运维
---

在日常开发和运维工作中，我们经常需要进入正在运行的Docker容器内部进行调试、查看日志或执行命令。虽然有多种方法可以实现这一目的，但有些方法并不推荐使用。本文将介绍几种常用的进入Docker容器的方法，并分析它们的优缺点。

## 方法一：使用docker exec（推荐）

这是进入运行中容器的**最佳方式**，也是官方推荐的方法。`docker exec` 命令可以在运行中的容器内执行命令，而不会影响容器的正常运行。

### 基本用法

```bash
# 首先查看正在运行的容器
$ sudo docker ps

# 使用容器ID进入容器
$ sudo docker exec -it 775c7c9ee1e1 /bin/bash
```

其中 `775c7c9ee1e1` 是容器的运行时ID（可以使用前几位唯一识别），`/bin/bash` 指定要执行的shell。

### 参数说明

- `-i`：保持标准输入打开（interactive）
- `-t`：分配一个伪终端（tty）
- `-it`：组合使用，提供交互式终端

### 使用容器名称进入

如果容器有名称，也可以直接使用名称：

```bash
$ sudo docker exec -it my-container-name /bin/bash
```

### 执行单条命令

如果只需要执行一条命令，可以不进入交互模式：

```bash
$ sudo docker exec my-container-name ls -la
```

## 方法二：使用docker attach

`docker attach` 命令可以连接到容器的主进程（PID 1），但这种方式有一些限制：

```bash
$ docker attach 775c7c9ee1e1
```

### 缺点

1. **共享输入输出**：所有连接到同一容器的用户都会共享同一个终端，输入会相互干扰
2. **退出问题**：如果在attach模式下按 `Ctrl+C`，可能会终止容器的主进程，导致容器停止
3. **只能连接主进程**：无法启动新的shell

### 适用场景

适合临时查看容器主进程的输出，不适合日常调试。

## 方法三：使用nsenter（高级）

`nsenter` 是一个更底层的工具，可以进入任意进程的命名空间。需要知道容器进程的PID：

```bash
# 获取容器进程PID
$ PID=$(docker inspect --format '{{.State.Pid}}' 775c7c9ee1e1)

# 使用nsenter进入容器
$ sudo nsenter --target $PID --mount --uts --ipc --net --pid
```

### 适用场景

这种方法功能强大，但比较复杂，适合需要深入容器内部进行调试的场景。

## 方法四：不推荐的方法

### 不推荐在容器内安装SSH服务

虽然可以在Docker镜像中安装SSH服务来实现远程登录，但这有以下缺点：

1. **增加镜像体积**
2. **增加安全风险**
3. **违背Docker的单进程原则**
4. **管理不便**

### 不推荐使用docker run启动新容器

```bash
# 这会创建一个新容器，而不是进入现有容器
$ docker run -it --rm ubuntu /bin/bash
```

## 实用技巧

### 1. 使用短ID

docker ps 输出的容器ID可以只使用前几位唯一的字符：

```bash
$ docker exec -it 775c /bin/bash  # 使用前4位即可
```

### 2. 设置别名

可以在 `~/.bashrc` 中设置别名方便使用：

```bash
alias denter='docker exec -it'
```

使用：

```bash
$ denter my-container /bin/bash
```

### 3. 指定不同的用户

可以使用 `-u` 参数指定运行命令的用户：

```bash
$ docker exec -it -u root my-container /bin/bash
```

### 4. 进入容器后退出

在容器内按 `Ctrl+D` 或输入 `exit` 退出，容器会继续运行。

## 总结

| 方法 | 优点 | 缺点 | 推荐度 |
|------|------|------|--------|
| `docker exec` | 安全、方便、不影响容器运行 | 无明显缺点 | ⭐⭐⭐⭐⭐ |
| `docker attach` | 简单直接 | 共享终端、可能终止容器 | ⭐⭐⭐ |
| `nsenter` | 功能强大、底层操作 | 复杂、需要root权限 | ⭐⭐⭐ |
| SSH服务 | 熟悉的SSH方式 | 不安全、增加镜像体积 | ⭐ |

**最佳实践**：日常开发调试使用 `docker exec -it <container> /bin/bash`，这是最安全、最方便的方式。