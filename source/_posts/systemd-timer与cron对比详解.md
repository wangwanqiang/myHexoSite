---
title: systemd timer 与 cron 对比详解
date: 2026-06-03 14:00:00
tags:
  - Linux
  - systemd
  - cron
  - 定时任务
categories:
  - Linux
  - 运维
---

## 前言

在 Linux 系统中，定时任务是不可或缺的功能。传统上，我们使用 `cron` 来执行周期性任务。但随着 `systemd` 成为主流初始化系统，`systemd timer` 作为现代化的定时任务方案，正在逐步取代 `cron` 的地位。

本文将详细对比这两种定时任务机制，帮助你理解它们的差异，并在实际场景中做出正确选择。

## 核心概念对比

| 特性 | cron | systemd timer |
|------|------|---------------|
| **诞生时间** | 1975 年（Unix V6） | 2010 年（systemd） |
| **设计理念** | 简单的定时执行 | 服务化、事件驱动 |
| **配置方式** | crontab 文件 | .timer + .service 单元文件 |
| **日志管理** | 依赖 syslog/mail | 原生集成 journald |
| **依赖管理** | 无 | 支持服务依赖（After/Before） |
| **失败处理** | 需自行实现 | 内置重启策略 |
| **执行环境** | 最小化环境 | 完整的服务上下文 |
| **持久化** | 无 | 支持 missed timer 补执行 |
| **精度** | 分钟级 | 微秒级 |

## cron 详解

### 基本语法

cron 使用五字段时间表达式：

```
┌───────────── 分钟 (0 - 59)
│ ┌───────────── 小时 (0 - 23)
│ │ ┌───────────── 日期 (1 - 31)
│ │ │ ┌───────────── 月份 (1 - 12)
│ │ │ │ ┌───────────── 星期 (0 - 7, 0 和 7 都是周日)
│ │ │ │ │
* * * * *  command
```

### 常用示例

```bash
# 每分钟执行
* * * * * /usr/local/bin/script.sh

# 每 5 分钟执行
*/5 * * * * /usr/local/bin/script.sh

# 每小时执行
0 * * * * /usr/local/bin/script.sh

# 每天凌晨 3 点执行
0 3 * * * /usr/local/bin/script.sh

# 每周一执行
0 0 * * 1 /usr/local/bin/script.sh

# 每月 1 号执行
0 0 1 * * /usr/local/bin/script.sh

# 工作日每 2 小时执行
0 */2 * * 1-5 /usr/local/bin/script.sh

# 复杂组合：周一到周五 9-18 点每 30 分钟执行
*/30 9-18 * * 1-5 /usr/local/bin/script.sh
```

### 特殊字符串

```bash
@reboot    # 系统启动时执行
@yearly    # 每年 1 月 1 日 0:00（等同于 0 0 1 1 *）
@monthly   # 每月 1 日 0:00（等同于 0 0 1 * *）
@weekly    # 每周日 0:00（等同于 0 0 * * 0）
@daily     # 每天 0:00（等同于 0 0 * * *）
@hourly    # 每小时 0 分（等同于 0 * * * *）
```

### 配置文件位置

| 文件/目录 | 说明 |
|-----------|------|
| `/etc/crontab` | 系统级 crontab |
| `/etc/cron.d/` | 系统级定时任务目录 |
| `/etc/cron.hourly/` | 每小时执行的脚本 |
| `/etc/cron.daily/` | 每天执行的脚本 |
| `/etc/cron.weekly/` | 每周执行的脚本 |
| `/etc/cron.monthly/` | 每月执行的脚本 |
| `/var/spool/cron/crontabs/` | 用户级 crontab |

### 环境变量设置

```bash
# 在 crontab 顶部设置环境变量
SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
MAILTO="admin@example.com"
HOME=/root

# 然后定义任务
0 3 * * * /usr/local/bin/backup.sh
```

### 优缺点

**优点**：
- ✅ 语法简单，学习成本低
- ✅ 几乎所有 Unix/Linux 系统都支持
- ✅ 轻量级，资源占用极低
- ✅  decades 的成熟稳定

**缺点**：
- ❌ 无原生日志，需自行重定向
- ❌ 执行失败无自动重试
- ❌ 最小化环境（PATH 等变量需手动设置）
- ❌ 无依赖管理
- ❌ 系统关机期间错过的任务不会补执行
- ❌ 分钟级精度

## systemd timer 详解

### 核心概念

systemd timer 由两个文件组成：

1. **.service 文件**：定义要执行的任务（做什么）
2. **.timer 文件**：定义触发时间（什么时候做）

```
my-task.timer ──→ my-task.service ──→ 执行命令
    (何时)           (做什么)
```

### 基本配置示例

#### 1. 创建 .service 文件

```ini
# /etc/systemd/system/my-backup.service
[Unit]
Description=Daily Backup Service
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh
User=backup
Group=backup
WorkingDirectory=/var/backup
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

#### 2. 创建 .timer 文件

```ini
# /etc/systemd/system/my-backup.timer
[Unit]
Description=Run backup daily at 3:00 AM

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

#### 3. 启用并启动

```bash
# 重新加载 systemd 配置
sudo systemctl daemon-reload

# 启用 timer（开机自启）
sudo systemctl enable my-backup.timer

# 启动 timer
sudo systemctl start my-backup.timer

# 查看状态
sudo systemctl status my-backup.timer
```

### Timer 触发类型

#### 1. 实时定时器（Realtime Timer）

使用 `OnCalendar` 指定绝对时间，类似 cron：

```ini
[Timer]
# 每天凌晨 3 点
OnCalendar=*-*-* 03:00:00

# 每 6 小时
OnCalendar=*-*-* 00/6:00:00

# 每周一 9:00
OnCalendar=Mon *-*-* 09:00:00

# 每月 1 号 0:00
OnCalendar=*-*-01 00:00:00

# 每年 1 月 1 日
OnCalendar=*-01-01 00:00:00

# 工作日每天 9:00-18:00 每 30 分钟
OnCalendar=Mon..Fri *-*-* 09..18:00/30:00

# 复杂表达式：每月第二个星期二
OnCalendar=Tue *-*-8..14 10:00:00
```

**OnCalendar 语法**：

```
DayOfWeek Year-Month-Day Hour:Minute:Second
```

| 通配符 | 含义 |
|--------|------|
| `*` | 任意值 |
| `,` | 列表分隔（如 `Mon,Wed,Fri`） |
| `..` | 范围（如 `Mon..Fri`） |
| `/` | 步进（如 `*/5` 每 5 个单位） |

#### 2. 单调定时器（Monotonic Timer）

基于系统状态变化触发：

```ini
[Timer]
# 系统启动后 10 分钟
OnBootSec=10min

# 首次激活后 5 分钟
OnActiveSec=5min

# 上次停止后 1 小时
OnUnitInactiveSec=1h

# 组合使用
OnBootSec=5min
OnUnitActiveSec=1h
```

| 选项 | 触发时机 |
|------|----------|
| `OnBootSec` | 系统启动后 |
| `OnStartupSec` | systemd 启动后 |
| `OnActiveSec` | timer 自身激活后 |
| `OnUnitActiveSec` | 关联 service 上次启动后 |
| `OnUnitInactiveSec` | 关联 service 上次停止后 |

#### 3. 组合定时器

```ini
[Timer]
# 系统启动 5 分钟后首次执行
OnBootSec=5min

# 之后每小时执行一次
OnUnitActiveSec=1h

# 同时每天凌晨 3 点执行
OnCalendar=*-*-* 03:00:00
```

### 高级特性

#### 持久化执行（Persistent）

```ini
[Timer]
OnCalendar=daily
Persistent=true
```

当 `Persistent=true` 时，如果系统关机期间错过了执行时间，开机后会立即补执行。这是 cron 无法做到的。

#### 随机延迟（RandomizedDelaySec）

```ini
[Timer]
OnCalendar=*-*-* 03:00:00
RandomizedDelaySec=30min
```

在 0-30 分钟之间随机延迟执行，避免多个服务器同时执行任务（如同时访问 API）。

#### 精度控制（AccuracySec）

```ini
[Timer]
OnCalendar=*-*-* 03:00:00
AccuracySec=1us
```

默认精度为 1 分钟，可以设置为微秒级。

#### 失败重试

```ini
# /etc/systemd/system/my-task.service
[Service]
Type=oneshot
ExecStart=/usr/local/bin/task.sh
Restart=on-failure
RestartSec=5min
StartLimitInterval=30min
StartLimitBurst=3
```

| 重启策略 | 说明 |
|----------|------|
| `no` | 不重启（默认） |
| `on-success` | 成功时重启 |
| `on-failure` | 失败时重启 |
| `on-abnormal` | 异常退出时重启 |
| `on-abort` | 被信号终止时重启 |
| `always` | 总是重启 |

### 日志查看

```bash
# 查看 timer 状态
sudo systemctl status my-task.timer

# 查看 service 执行日志
sudo journalctl -u my-task.service

# 查看最近 10 条日志
sudo journalctl -u my-task.service -n 10

# 实时跟踪日志
sudo journalctl -u my-task.service -f

# 查看今天的日志
sudo journalctl -u my-task.service --since today

# 查看特定时间范围的日志
sudo journalctl -u my-task.service --since "2026-06-01 00:00:00" --until "2026-06-03 23:59:59"

# 查看所有 timer 的下次执行时间
systemctl list-timers --all
```

### 管理命令

```bash
# 列出所有 timer
systemctl list-timers

# 列出所有 timer（包括未激活的）
systemctl list-timers --all

# 查看 timer 详细信息
systemctl show my-task.timer

# 查看 service 详细信息
systemctl show my-task.service

# 手动触发一次 service（不影响 timer 计划）
sudo systemctl start my-task.service

# 停止 timer
sudo systemctl stop my-task.timer

# 禁用 timer（取消开机自启）
sudo systemctl disable my-task.timer

# 重新加载配置
sudo systemctl daemon-reload
```

## 实战对比

### 场景一：每天备份数据库

#### cron 方案

```bash
# crontab -e
0 3 * * * /usr/local/bin/backup-db.sh >> /var/log/backup.log 2>&1
```

**问题**：
- 日志需手动重定向
- 失败无通知
- 关机期间错过不补执行

#### systemd timer 方案

```ini
# /etc/systemd/system/db-backup.service
[Unit]
Description=Database Backup
After=network.target postgresql.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup-db.sh
User=postgres
StandardOutput=journal
StandardError=journal
Restart=on-failure
RestartSec=10min

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/db-backup.timer
[Unit]
Description=Run database backup daily at 3:00 AM

[Timer]
OnCalendar=*-*-* 03:00:00
Persistent=true
RandomizedDelaySec=10min

[Install]
WantedBy=timers.target
```

**优势**：
- 依赖 PostgreSQL 服务启动
- 失败自动重试
- 关机错过自动补执行
- 日志集中管理
- 随机延迟避免资源竞争

### 场景二：系统启动后初始化

#### cron 方案

```bash
# 使用 @reboot（但环境变量不完整）
@reboot /usr/local/bin/init.sh
```

#### systemd timer 方案

```ini
# /etc/systemd/system/init-config.timer
[Unit]
Description=Run initialization after boot

[Timer]
OnBootSec=2min
OnUnitActiveSec=1h

[Install]
WantedBy=timers.target
```

```ini
# /etc/systemd/system/init-config.service
[Unit]
Description=System Initialization
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/init.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**优势**：
- 确保网络就绪后执行
- 可以设置启动延迟
- 失败可重试

### 场景三：监控服务健康状态

#### systemd timer 方案（cron 难以实现）

```ini
# /etc/systemd/system/health-check.service
[Unit]
Description=Health Check
After=nginx.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/health-check.sh
ExecStopPost=/usr/local/bin/alert-if-failed.sh

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/health-check.timer
[Unit]
Description=Run health check every 5 minutes

[Timer]
OnBootSec=1min
OnUnitActiveSec=5min
AccuracySec=1s

[Install]
WantedBy=timers.target
```

## 选择建议

| 场景 | 推荐方案 | 理由 |
|------|----------|------|
| 简单的周期性脚本 | cron | 配置简单，轻量级 |
| 需要日志和监控 | systemd timer | 原生 journald 集成 |
| 服务依赖管理 | systemd timer | After/Before/Wants |
| 失败需要重试 | systemd timer | Restart=on-failure |
| 关机期间需补执行 | systemd timer | Persistent=true |
| 系统启动初始化 | systemd timer | OnBootSec + 依赖 |
| 跨平台兼容 | cron | 所有 Unix 都支持 |
| 嵌入式/资源受限 | cron | 更轻量 |
| 微秒级精度 | systemd timer | AccuracySec=1us |
| 临时快速测试 | cron | crontab -e 即可 |

## 迁移指南：从 cron 到 systemd timer

### 迁移步骤

1. **分析现有 cron 任务**

```bash
# 导出所有 cron 任务
crontab -l > /tmp/cron-backup.txt
cat /etc/crontab >> /tmp/cron-backup.txt
ls /etc/cron.d/ >> /tmp/cron-backup.txt
```

2. **创建对应的 .service 文件**

3. **创建对应的 .timer 文件**

4. **测试并启用**

5. **移除旧的 cron 任务**

### 迁移示例

**原 cron 任务**：

```bash
# crontab -l
0 2 * * * /usr/local/bin/backup.sh /data >> /var/log/backup.log 2>&1
```

**迁移为 systemd timer**：

```ini
# /etc/systemd/system/data-backup.service
[Unit]
Description=Data Backup

[Service]
Type=oneshot
ExecStart=/usr/local/bin/backup.sh /data
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
```

```ini
# /etc/systemd/system/data-backup.timer
[Unit]
Description=Run data backup daily at 2:00 AM

[Timer]
OnCalendar=*-*-* 02:00:00
Persistent=true

[Install]
WantedBy=timers.target
```

```bash
# 启用
sudo systemctl daemon-reload
sudo systemctl enable --now data-backup.timer

# 验证
systemctl list-timers data-backup.timer
journalctl -u data-backup.service
```

## 常见问题

### Q: systemd timer 会替代 cron 吗？

A: 在现代 Linux 发行版（如 RHEL 8+、Ubuntu 20.04+、Debian 10+）中，systemd timer 已成为推荐方案。但 cron 仍被广泛支持，两者可以共存。

### Q: 如何查看所有 timer 的下次执行时间？

```bash
systemctl list-timers --all
```

输出示例：

```
NEXT                        LEFT          LAST                        PASSED       UNIT                         ACTIVATES
Thu 2026-06-04 03:00:00 CST 11h left      Wed 2026-06-03 03:00:01 CST 9h ago       my-backup.timer              my-backup.service
Thu 2026-06-04 09:00:00 CST 17h left      Wed 2026-06-03 09:00:00 CST 3h ago       health-check.timer           health-check.service
```

### Q: timer 和 service 命名必须一致吗？

A: 默认情况下，timer 会寻找同名的 service。但可以通过 `Unit=` 指定不同名称：

```ini
[Timer]
Unit=my-custom-name.service
```

### Q: 如何临时禁用某个 timer？

```bash
sudo systemctl stop my-task.timer
sudo systemctl disable my-task.timer
```

### Q: 如何在用户空间创建 timer？

```bash
# 不需要 sudo，放在用户目录
mkdir -p ~/.config/systemd/user/
cp my-task.service ~/.config/systemd/user/
cp my-task.timer ~/.config/systemd/user/

systemctl --user daemon-reload
systemctl --user enable --now my-task.timer
```

## 总结

| 维度 | cron | systemd timer |
|------|------|---------------|
| **易用性** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |
| **功能性** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **可靠性** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **可观测性** | ⭐⭐ | ⭐⭐⭐⭐⭐ |
| **生态集成** | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| **兼容性** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

**建议**：
- 新项目优先使用 **systemd timer**
- 简单个人任务可以使用 **cron**
- 关键生产任务务必使用 **systemd timer**（日志、重试、依赖管理）
- 遗留系统可逐步迁移

systemd timer 代表了 Linux 定时任务的未来方向，其服务化、事件驱动的设计理念，与现代云原生架构更加契合。掌握 systemd timer，是每一位 Linux 运维和开发者的必备技能。
