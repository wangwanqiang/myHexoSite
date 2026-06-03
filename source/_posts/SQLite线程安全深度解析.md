---
title: SQLite 线程安全深度解析
date: 2026-06-03 12:00:00
tags:
  - SQLite
  - 并发
  - 线程安全
  - 数据库
categories:
  - 数据库
---

## 前言

SQLite 作为世界上最流行的嵌入式数据库，其线程安全性是开发者最关心的问题之一。与 PostgreSQL、MySQL 等客户端/服务器架构的数据库不同，SQLite 直接嵌入在应用程序中运行，因此对线程模型的理解至关重要。

本文将从 SQLite 的三种线程模式出发，深入剖析其线程安全机制，并结合实际场景给出最佳实践建议。

## SQLite 线程模式概览

SQLite 支持 **三种线程模式**，从完全不安全到完全安全：

| 模式 | 值 | 说明 | 适用场景 |
|------|-----|------|----------|
| **Single-thread** | 0 | 禁用所有互斥锁，完全线程不安全 | 单线程应用 |
| **Multi-thread** | 2 | 多个线程可同时使用不同连接 | 每个线程独立连接 |
| **Serialized** | 1 | 多个线程可安全共享同一连接（默认） | 连接池、多线程共享 |

> **注意**：SQLite 从 **3.3.1 版本（2006年）** 开始就是线程安全的，默认模式为 Serialized。

## 三种线程模式详解

### 1. Single-thread 模式（单线程模式）

在单线程模式下，SQLite 编译时**完全移除了互斥锁逻辑**，因此：

- ❌ 禁止在多线程环境中使用
- ❌ 即使每个线程使用独立连接也不安全
- ✅ 性能最高（无锁开销）
- ✅ 库体积最小

**启用方式**：

```c
// 编译时
-DSQLITE_THREADSAFE=0

// 运行时查询
sqlite3_threadsafe();  // 返回 0
```

### 2. Multi-thread 模式（多线程模式）

多线程模式的核心规则：**一个数据库连接（sqlite3）及其派生对象（如 prepared statement）不能同时被多个线程使用**。

```
线程 A ──→ 连接 1 ──→ 安全
线程 B ──→ 连接 2 ──→ 安全

线程 A ──→ 连接 1 ──┐
线程 B ──→ 连接 1 ──┘  ❌ 不安全！
```

**特点**：
- ✅ 多个线程可同时使用**不同**的数据库连接
- ❌ 同一连接不能跨线程共享
- ✅ 比 Serialized 模式性能略高（连接级别无锁）
- ✅ 适合每个线程独立管理连接的场景

**启用方式**：

```c
// 编译时
-DSQLITE_THREADSAFE=2

// 启动时
sqlite3_config(SQLITE_CONFIG_MULTITHREAD);

// 运行时查询
sqlite3_threadsafe();  // 返回 2
```

### 3. Serialized 模式（串行化模式）

Serialized 是 SQLite 的**默认模式**。在此模式下：

- ✅ 多个线程可以安全地共享同一个数据库连接
- ✅ SQLite 内部使用互斥锁（mutex）序列化对连接对象的访问
- ✅ 对单个对象的效果等同于单线程按顺序调用
- ⚠️ 有互斥锁开销，性能略低于 Multi-thread 模式

```
线程 A ──→ 连接 1 ──┐
线程 B ──→ 连接 1 ──┤  ✅ 安全！SQLite 内部加锁
线程 C ──→ 连接 1 ──┘
```

**启用方式**：

```c
// 编译时（默认）
-DSQLITE_THREADSAFE=1

// 启动时
sqlite3_config(SQLITE_CONFIG_SERIALIZED);

// 运行时查询
sqlite3_threadsafe();  // 返回 1
```

## 线程模式的优先级

SQLite 的线程模式可以在三个层面设置，优先级为：**运行时 > 启动时 > 编译时**

```
编译时 (SQLITE_THREADSAFE) 
    ↓
启动时 (sqlite3_config) 
    ↓
运行时 (sqlite3_open_v2 flags)
    ↓
最终生效的线程模式
```

**重要限制**：
- 如果编译时设置为 Single-thread（0），则**无法**在启动时或运行时改为其他模式
- 运行时只能降低线程安全级别（如从 Serialized 改为 Multi-thread），不能提升

## 线程模式设置代码示例

### C/C++

```c
#include <sqlite3.h>
#include <stdio.h>

int main() {
    // 1. 查看编译时的线程模式
    int compileMode = sqlite3_threadsafe();
    printf("Compile-time threadsafe: %d\n", compileMode);
    // 0=single-thread, 1=serialized, 2=multi-thread
    
    // 2. 启动时设置线程模式（必须在任何其他 SQLite 调用之前）
    sqlite3_config(SQLITE_CONFIG_SERIALIZED);  // 或 MULTITHREAD
    
    // 3. 运行时打开连接时指定模式
    sqlite3 *db;
    int flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE;
    
    // 使用 FULLMUTEX 强制 serialized 模式
    flags |= SQLITE_OPEN_FULLMUTEX;
    
    // 或使用 NOMUTEX 强制 multi-thread 模式
    // flags |= SQLITE_OPEN_NOMUTEX;
    
    int rc = sqlite3_open_v2("test.db", &db, flags, NULL);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "Cannot open database: %s\n", sqlite3_errmsg(db));
        return 1;
    }
    
    // 使用数据库...
    
    sqlite3_close(db);
    return 0;
}
```

### Python

```python
import sqlite3

# 查看 Python 内置 SQLite 的线程安全级别
# sqlite3.threadsafety 值含义：
# 0 = single-thread, 1 = multi-thread, 3 = serialized
print(f"Thread safety level: {sqlite3.threadsafety}")

# Python 的 sqlite3 模块默认是 serialized 模式
# 创建连接时可以通过 check_same_thread 参数控制

# 方式一：禁止跨线程使用（multi-thread 模式行为）
conn = sqlite3.connect('test.db', check_same_thread=True)

# 方式二：允许跨线程使用（serialized 模式行为，默认）
conn = sqlite3.connect('test.db', check_same_thread=False)

# 注意：即使 check_same_thread=False，Python GIL 也会提供一定保护
# 但高并发时仍建议配合锁使用
```

### Java (JDBC)

```java
import java.sql.*;
import org.sqlite.SQLiteConfig;

public class SQLiteThreadSafety {
    public static void main(String[] args) throws Exception {
        SQLiteConfig config = new SQLiteConfig();
        
        // 设置线程模式
        // 0 = SINGLE_THREAD, 1 = MULTI_THREAD, 2 = SERIALIZED
        config.setPragma(SQLiteConfig.Pragma.THREAD_SAFE, "2"); // SERIALIZED
        
        Connection conn = DriverManager.getConnection(
            "jdbc:sqlite:test.db", 
            config.toProperties()
        );
        
        // 使用连接...
        
        conn.close();
    }
}
```

## 多线程最佳实践

### 实践一：每个线程一个连接（推荐）

这是最安全、性能最好的方案。每个线程维护自己的数据库连接，完全避免线程竞争。

```python
import sqlite3
import threading

class ThreadLocalConnection:
    """每个线程拥有独立的数据库连接"""
    
    def __init__(self, db_path):
        self.db_path = db_path
        self.local = threading.local()
    
    def get_connection(self):
        """获取当前线程的连接"""
        if not hasattr(self.local, 'conn') or self.local.conn is None:
            self.local.conn = sqlite3.connect(self.db_path)
            # 启用 WAL 模式提升并发性能
            self.local.conn.execute('PRAGMA journal_mode=WAL')
        return self.local.conn
    
    def execute(self, sql, params=()):
        """在当前线程执行 SQL"""
        conn = self.get_connection()
        with conn:  # 自动事务
            return conn.execute(sql, params).fetchall()
    
    def close(self):
        """关闭当前线程的连接"""
        if hasattr(self.local, 'conn') and self.local.conn:
            self.local.conn.close()
            self.local.conn = None

# 使用示例
db = ThreadLocalConnection('app.db')

def worker(thread_id):
    db.execute('INSERT INTO logs (thread_id, message) VALUES (?, ?)', 
               (thread_id, f'Hello from thread {thread_id}'))

threads = [threading.Thread(target=worker, args=(i,)) for i in range(10)]
for t in threads:
    t.start()
for t in threads:
    t.join()
```

### 实践二：连接池模式

当线程数量较多时，为每个线程创建连接可能消耗过多资源。此时可以使用连接池：

```python
import sqlite3
import threading
from queue import Queue

class SQLiteConnectionPool:
    """SQLite 连接池"""
    
    def __init__(self, db_path, pool_size=5):
        self.db_path = db_path
        self.pool = Queue(maxsize=pool_size)
        self.lock = threading.Lock()
        
        # 预创建连接
        for _ in range(pool_size):
            conn = sqlite3.connect(db_path, check_same_thread=False)
            conn.execute('PRAGMA journal_mode=WAL')
            self.pool.put(conn)
    
    def acquire(self):
        """获取连接"""
        return self.pool.get()
    
    def release(self, conn):
        """归还连接"""
        self.pool.put(conn)
    
    def execute(self, sql, params=()):
        """执行 SQL（自动获取/归还连接）"""
        conn = self.acquire()
        try:
            with conn:
                result = conn.execute(sql, params).fetchall()
            return result
        finally:
            self.release(conn)
    
    def close_all(self):
        """关闭所有连接"""
        while not self.pool.empty():
            conn = self.pool.get()
            conn.close()

# 使用示例
pool = SQLiteConnectionPool('app.db', pool_size=5)

def worker(thread_id):
    pool.execute('INSERT INTO logs (thread_id) VALUES (?)', (thread_id,))

threads = [threading.Thread(target=worker, args=(i,)) for i in range(20)]
for t in threads:
    t.start()
for t in threads:
    t.join()
```

### 实践三：单连接 + 显式锁

如果必须使用单个连接跨线程共享，需要显式加锁：

```python
import sqlite3
import threading

class LockedSQLite:
    """单连接 + 线程锁"""
    
    def __init__(self, db_path):
        self.conn = sqlite3.connect(db_path, check_same_thread=False)
        self.conn.execute('PRAGMA journal_mode=WAL')
        self.lock = threading.RLock()  # 可重入锁
    
    def execute(self, sql, params=()):
        """线程安全地执行 SQL"""
        with self.lock:
            with self.conn:
                return self.conn.execute(sql, params).fetchall()
    
    def executemany(self, sql, params_list):
        """线程安全地批量执行"""
        with self.lock:
            with self.conn:
                return self.conn.executemany(sql, params_list)
    
    def close(self):
        with self.lock:
            self.conn.close()

# 使用示例
db = LockedSQLite('app.db')

def worker(thread_id):
    db.execute('INSERT INTO logs (thread_id) VALUES (?)', (thread_id,))

threads = [threading.Thread(target=worker, args=(i,)) for i in range(10)]
for t in threads:
    t.start()
for t in threads:
    t.join()
```

## WAL 模式与并发性能

无论选择哪种线程模式，启用 **WAL（Write-Ahead Logging）** 模式都能显著提升并发性能：

```sql
PRAGMA journal_mode=WAL;
```

### WAL 模式的优势

| 特性 | DELETE 模式（默认） | WAL 模式 |
|------|---------------------|----------|
| 读写并发 | 写时阻塞读 | 读写可并发 |
| 写性能 | 较低 | 较高（10-20 倍提升） |
| 数据安全性 | 高 | 高 |
| 兼容性 | 最好 | 需要 SQLite 3.7.0+ |

### WAL 模式下的并发规则

```
读取者 ──→ 可以同时有多个
    ↓
写入者 ──→ 同一时间只能有一个
    ↓
检查点 ──→ 将 WAL 文件合并到主数据库
```

```python
# 启用 WAL 模式
conn = sqlite3.connect('app.db')
conn.execute('PRAGMA journal_mode=WAL')

# 可选：自动检查点配置
conn.execute('PRAGMA wal_autocheckpoint=1000')  # 每 1000 页自动检查点
```

## 常见陷阱与解决方案

### 陷阱一：Prepared Statement 跨线程使用

```python
# ❌ 错误：Prepared Statement 跨线程共享
stmt = conn.prepare("INSERT INTO users (name) VALUES (?)")

def worker():
    stmt.execute(("Alice",))  # 可能崩溃！

# ✅ 正确：每个线程创建自己的 Statement

def worker():
    stmt = conn.prepare("INSERT INTO users (name) VALUES (?)")
    stmt.execute(("Alice",))
```

### 陷阱二：事务跨线程

```python
# ❌ 错误：事务开始和提交在不同线程
# 线程 A
conn.execute('BEGIN')

# 线程 B
conn.execute('INSERT INTO ...')

# 线程 A
conn.execute('COMMIT')  # 可能出错！

# ✅ 正确：事务在同一个线程内完成
def worker(conn):
    with conn:  # 自动 BEGIN/COMMIT/ROLLBACK
        conn.execute('INSERT INTO ...')
```

### 陷阱三：忽略 busy timeout

```python
# ❌ 错误：默认 busy timeout 为 0，立即返回 SQLITE_BUSY
conn = sqlite3.connect('app.db')

# ✅ 正确：设置合理的 busy timeout
conn = sqlite3.connect('app.db')
conn.execute('PRAGMA busy_timeout=5000')  # 等待 5 秒
```

## 线程安全检测工具

### 检测当前 SQLite 的线程模式

```python
import sqlite3

def check_thread_safety():
    """检测 SQLite 线程安全级别"""
    safety_map = {
        0: "SINGLE_THREAD (单线程，完全不安全)",
        1: "MULTI_THREAD (多线程，连接不共享)",
        3: "SERIALIZED (串行化，完全线程安全)"
    }
    
    level = sqlite3.threadsafety
    print(f"SQLite 线程安全级别: {level}")
    print(f"模式: {safety_map.get(level, '未知')}")
    
    # 验证 WAL 模式
    conn = sqlite3.connect(':memory:')
    journal_mode = conn.execute('PRAGMA journal_mode').fetchone()[0]
    print(f"默认日志模式: {journal_mode}")
    conn.close()

check_thread_safety()
```

### 并发压力测试

```python
import sqlite3
import threading
import time
import random

def stress_test(db_path, num_threads=10, operations_per_thread=100):
    """SQLite 并发压力测试"""
    
    # 初始化数据库
    conn = sqlite3.connect(db_path)
    conn.execute('CREATE TABLE IF NOT EXISTS counter (id INTEGER PRIMARY KEY, count INTEGER)')
    conn.execute('INSERT OR REPLACE INTO counter VALUES (1, 0)')
    conn.execute('PRAGMA journal_mode=WAL')
    conn.close()
    
    errors = []
    
    def worker():
        local_conn = sqlite3.connect(db_path)
        local_conn.execute('PRAGMA busy_timeout=5000')
        
        for _ in range(operations_per_thread):
            try:
                with local_conn:
                    # 读取
                    cur = local_conn.execute('SELECT count FROM counter WHERE id=1')
                    count = cur.fetchone()[0]
                    
                    # 模拟处理时间
                    time.sleep(random.uniform(0.001, 0.01))
                    
                    # 写入
                    local_conn.execute('UPDATE counter SET count=? WHERE id=1', (count + 1,))
            except sqlite3.Error as e:
                errors.append(str(e))
        
        local_conn.close()
    
    start = time.time()
    threads = [threading.Thread(target=worker) for _ in range(num_threads)]
    for t in threads:
        t.start()
    for t in threads:
        t.join()
    elapsed = time.time() - start
    
    # 验证结果
    conn = sqlite3.connect(db_path)
    final_count = conn.execute('SELECT count FROM counter WHERE id=1').fetchone()[0]
    conn.close()
    
    expected = num_threads * operations_per_thread
    
    print(f"线程数: {num_threads}")
    print(f"每线程操作数: {operations_per_thread}")
    print(f"总操作数: {expected}")
    print(f"最终计数: {final_count}")
    print(f"是否一致: {'✅' if final_count == expected else '❌'}")
    print(f"错误数: {len(errors)}")
    print(f"耗时: {elapsed:.2f}秒")
    print(f"TPS: {expected/elapsed:.0f}")

# 运行测试
stress_test('stress_test.db', num_threads=20, operations_per_thread=50)
```

## 总结

| 场景 | 推荐方案 | 线程模式 | WAL |
|------|----------|----------|-----|
| 单线程应用 | 直接使用 | Single-thread | 可选 |
| 多线程，每个线程独立连接 | ThreadLocal 连接 | Multi-thread | ✅ 启用 |
| 多线程，连接池 | 连接池管理 | Serialized | ✅ 启用 |
| 多线程，必须共享连接 | 显式锁保护 | Serialized | ✅ 启用 |
| 高并发读写 | 每个线程独立连接 + WAL | Multi-thread | ✅ 必须 |

### 核心要点

1. **默认安全**：SQLite 默认是 Serialized 模式，多线程共享连接是安全的
2. **连接隔离**：Multi-thread 模式下，不同线程使用不同连接是最高效的方式
3. **WAL 必备**：高并发场景务必启用 WAL 模式
4. **Busy Timeout**：设置合理的 busy_timeout 避免 SQLITE_BUSY 错误
5. **Statement 不共享**：Prepared Statement 不能跨线程使用
6. **事务原子性**：BEGIN/COMMIT 必须在同一线程完成

理解 SQLite 的线程模型，合理选择线程模式和并发策略，就能在享受 SQLite 轻量便捷的同时，获得可靠的并发性能。
