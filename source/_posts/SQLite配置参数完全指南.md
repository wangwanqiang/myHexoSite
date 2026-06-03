---
title: SQLite 配置参数完全指南
date: 2026-06-03 13:00:00
tags:
  - SQLite
  - 配置
  - PRAGMA
  - 数据库
categories:
  - 数据库
---

## 前言

SQLite 作为嵌入式数据库的王者，其强大之处不仅在于零配置、零管理，更在于其丰富的 PRAGMA 指令系统。通过 PRAGMA，开发者可以精细控制 SQLite 的运行时行为、查询优化、内存管理、并发策略等方方面面。

本文将系统梳理 SQLite 的 PRAGMA 配置参数，按照功能分类，帮助你全面掌握 SQLite 的调优技巧。

## PRAGMA 基础

PRAGMA 是 SQLite 特有的 SQL 扩展，用于查询或修改 SQLite 库的内部状态：

```sql
-- 查询当前值
PRAGMA journal_mode;

-- 设置新值（等号语法）
PRAGMA journal_mode = WAL;

-- 设置新值（括号语法）
PRAGMA journal_mode(WAL);

-- 查询特定数据库
PRAGMA main.journal_mode;
PRAGMA temp.cache_size;
```

**重要特性**：
- PRAGMA 是 SQLite 特有，不兼容其他数据库
- 未知 PRAGMA 被静默忽略（不会报错）
- 部分 PRAGMA 在 SQL 编译阶段生效，而非执行阶段

## 一、事务与日志配置

### journal_mode — 日志模式

控制 SQLite 的事务日志机制，是影响并发性能的核心参数。

| 模式 | 说明 | 适用场景 |
|------|------|----------|
| `DELETE` | 默认模式，事务结束时删除日志文件 | 简单应用 |
| `TRUNCATE` | 事务结束时截断日志文件 | 文件系统不支持删除时 |
| `PERSIST` | 保留日志文件，只清零头部 | 文件系统不支持删除时 |
| `MEMORY` | 日志存储在内存中 | 临时数据库 |
| `WAL` | 预写日志，读写并发 | **高并发首选** |
| `OFF` | 无日志，最快但不安全 | 只读或临时数据 |

```sql
-- 查看当前模式
PRAGMA journal_mode;

-- 启用 WAL 模式（推荐）
PRAGMA journal_mode = WAL;

-- WAL 模式下的检查点控制
PRAGMA wal_autocheckpoint = 1000;  -- 每 1000 页自动检查点
PRAGMA wal_checkpoint(TRUNCATE);    -- 手动触发检查点
```

**WAL 模式优势**：
- 读写可并发（读不阻塞写，写不阻塞读）
- 写性能提升 10-20 倍
- 崩溃恢复更快

### synchronous — 同步级别

控制事务提交时的磁盘同步策略，平衡安全性与性能。

| 级别 | 值 | 说明 | 数据安全 | 性能 |
|------|-----|------|----------|------|
| `OFF` | 0 | 不同步 | 最低 | 最高 |
| `NORMAL` | 1 | 关键数据同步 | 中等 | 中等 |
| `FULL` | 2 | 完全同步（默认） | 最高 | 最低 |
| `EXTRA` | 3 | 额外同步 | 最高+ | 最低 |

```sql
-- 查看当前设置
PRAGMA synchronous;

-- 开发环境：追求性能
PRAGMA synchronous = NORMAL;

-- 生产环境：追求安全
PRAGMA synchronous = FULL;

-- 临时导入数据：追求极致速度
PRAGMA synchronous = OFF;
-- ... 批量导入 ...
PRAGMA synchronous = FULL;  -- 恢复安全设置
```

### locking_mode — 锁定模式

| 模式 | 说明 |
|------|------|
| `NORMAL` | 默认，每个事务结束时释放锁 |
| `EXCLUSIVE` | 首次访问后保持排他锁直到连接关闭 |

```sql
PRAGMA locking_mode = EXCLUSIVE;  -- 提升单连接性能
```

### busy_timeout — 忙等待超时

当数据库被锁定时，等待多少毫秒后返回 SQLITE_BUSY 错误。

```sql
-- 默认 0（立即返回错误）
PRAGMA busy_timeout;

-- 设置 5 秒超时
PRAGMA busy_timeout = 5000;

-- 使用 busy_handler 替代
PRAGMA busy_timeout = 0;  -- 禁用内置超时，使用自定义 handler
```

## 二、内存与缓存配置

### cache_size — 页面缓存大小

控制每个数据库连接的内存缓存页数。

```sql
-- 正数：缓存页数
PRAGMA cache_size = 2000;

-- 负数：缓存大小（KB）
PRAGMA cache_size = -4096;  -- 约 4MB 缓存

-- 查看当前值
PRAGMA cache_size;
```

**计算示例**：
- 默认页大小 4096 字节
- `cache_size = -2000` = 约 2MB 缓存
- `cache_size = 5000` = 5000 页 × 4KB = 约 20MB

### mmap_size — 内存映射大小

启用内存映射 I/O，将数据库文件直接映射到进程地址空间。

```sql
-- 查看当前限制
PRAGMA mmap_size;

-- 启用 2GB 内存映射
PRAGMA mmap_size = 2147483648;

-- 禁用内存映射
PRAGMA mmap_size = 0;
```

**优势**：
- 减少系统调用开销
- 利用操作系统缓存
- 适合大文件只读场景

### temp_store — 临时存储位置

| 值 | 说明 |
|-----|------|
| 0 | 默认（编译时决定） |
| 1 | 文件 |
| 2 | 内存 |
| 3 | 内存（强制） |

```sql
PRAGMA temp_store = MEMORY;  -- 临时表和索引存内存
```

### page_size — 页面大小

数据库文件的页大小，影响 I/O 效率和存储空间。

```sql
-- 查看当前页大小
PRAGMA page_size;

-- 设置新页大小（仅对新数据库有效）
PRAGMA page_size = 4096;  -- 默认
PRAGMA page_size = 8192;  -- 大页，适合大记录
PRAGMA page_size = 1024;  -- 小页，适合小记录
```

**选择建议**：
- 小记录（< 1KB）：1024 或 2048
- 中等记录（1-4KB）：4096（默认，最通用）
- 大记录（> 4KB）：8192 或 16384

## 三、查询优化配置

### query_only — 只读模式

```sql
PRAGMA query_only = ON;   -- 禁止所有修改操作
PRAGMA query_only = OFF;  -- 恢复正常（默认）
```

### automatic_index — 自动索引

控制 SQLite 是否自动为没有合适索引的查询创建临时索引。

```sql
PRAGMA automatic_index = ON;   -- 默认，自动创建临时索引
PRAGMA automatic_index = OFF;  -- 禁用，避免意外开销
```

### reverse_unordered_selects — 反转无序查询

调试用途，反转没有 ORDER BY 的 SELECT 结果顺序。

```sql
PRAGMA reverse_unordered_selects = ON;  -- 测试代码是否依赖默认顺序
```

### optimize — 查询优化器

```sql
-- 运行 ANALYZE 并优化查询计划
PRAGMA optimize;

-- 指定优化级别
PRAGMA optimize(0x10002);  -- 分析索引并更新统计信息
```

### analysis_limit — 分析限制

限制 ANALYZE 命令扫描的行数，加速大表分析。

```sql
PRAGMA analysis_limit = 1000;  -- 每索引最多分析 1000 行
```

## 四、外键与约束配置

### foreign_keys — 外键约束

```sql
-- 查看外键是否启用
PRAGMA foreign_keys;

-- 启用外键约束（默认关闭，需手动开启）
PRAGMA foreign_keys = ON;

-- 禁用外键约束
PRAGMA foreign_keys = OFF;
```

> **重要**：外键默认关闭！需要在每个连接中手动启用。

### defer_foreign_keys — 延迟外键检查

```sql
PRAGMA defer_foreign_keys = ON;  -- 延迟到事务提交时检查
```

### ignore_check_constraints — 忽略检查约束

```sql
PRAGMA ignore_check_constraints = ON;  -- 临时禁用 CHECK 约束
```

## 五、数据完整性配置

### integrity_check — 完整性检查

```sql
-- 完整检查
PRAGMA integrity_check;

-- 快速检查（仅检查索引）
PRAGMA integrity_check(10);  -- 最多报告 10 个错误

-- 检查特定表
PRAGMA integrity_check('users');
```

### quick_check — 快速检查

```sql
PRAGMA quick_check;  -- 比 integrity_check 更快，检查较少
```

### foreign_key_check — 外键检查

```sql
-- 检查所有表的外键约束
PRAGMA foreign_key_check;

-- 检查特定表
PRAGMA foreign_key_check('orders');
```

### cell_size_check — 单元格大小检查

```sql
PRAGMA cell_size_check = ON;  -- 调试用途，检查每页单元格大小
```

## 六、存储与空间管理

### auto_vacuum — 自动清理

| 模式 | 说明 |
|------|------|
| `NONE` (0) | 默认，不自动清理 |
| `FULL` (1) | 每次提交时自动清理 |
| `INCREMENTAL` (2) | 增量清理，需手动触发 |

```sql
-- 查看当前模式
PRAGMA auto_vacuum;

-- 启用增量清理
PRAGMA auto_vacuum = INCREMENTAL;

-- 执行增量清理
PRAGMA incremental_vacuum(100);  -- 回收 100 页
```

**注意**：auto_vacuum 只能在空数据库时设置，或执行 VACUUM 后更改。

### incremental_vacuum — 增量清理

```sql
PRAGMA incremental_vacuum;       -- 清理所有可回收页面
PRAGMA incremental_vacuum(100);  -- 最多清理 100 页
```

### freelist_count — 空闲页数量

```sql
PRAGMA freelist_count;  -- 返回数据库中可重用的空闲页数
```

### max_page_count — 最大页数

限制数据库文件的最大大小。

```sql
PRAGMA max_page_count = 1073741823;  -- 约 4TB（默认）
PRAGMA max_page_count = 100000;       -- 限制为约 400MB
```

### journal_size_limit — 日志大小限制

```sql
PRAGMA journal_size_limit = 10485760;  -- 限制日志为 10MB
```

### secure_delete — 安全删除

```sql
PRAGMA secure_delete = ON;   -- 删除时清零数据（更安全，更慢）
PRAGMA secure_delete = OFF;  -- 默认，直接删除（更快）
PRAGMA secure_delete = FAST; -- 3.36.0+，快速安全删除
```

## 七、编码与格式配置

### encoding — 数据库编码

```sql
-- 查看编码
PRAGMA encoding;

-- 设置编码（仅对新数据库有效）
PRAGMA encoding = 'UTF-8';     -- 默认
PRAGMA encoding = 'UTF-16';    -- UTF-16 原生
PRAGMA encoding = 'UTF-16le';  -- UTF-16 小端
PRAGMA encoding = 'UTF-16be';  -- UTF-16 大端
```

### legacy_file_format — 兼容旧格式

```sql
PRAGMA legacy_file_format = ON;   -- 创建兼容旧版本的文件
PRAGMA legacy_file_format = OFF;  -- 默认，使用最新格式
```

### legacy_alter_table — 兼容旧 ALTER TABLE

```sql
PRAGMA legacy_alter_table = ON;   -- 3.25.0 之前的 ALTER TABLE 行为
```

## 八、调试与诊断配置

### parser_trace — 解析器追踪

```sql
PRAGMA parser_trace = ON;   -- 输出 SQL 解析过程
PRAGMA parser_trace = OFF;  -- 默认
```

### vdbe_trace — 虚拟机追踪

```sql
PRAGMA vdbe_trace = ON;   -- 输出 VDBE 执行步骤
PRAGMA vdbe_trace = OFF;  -- 默认
```

### vdbe_debug — 调试模式

```sql
PRAGMA vdbe_debug = ON;   -- 详细调试输出
PRAGMA vdbe_debug = OFF;  -- 默认
```

### vdbe_listing — 字节码列表

```sql
PRAGMA vdbe_listing = ON;   -- 输出 VDBE 字节码
PRAGMA vdbe_listing = OFF;  -- 默认
```

### vdbe_addoptrace — 操作码追踪

```sql
PRAGMA vdbe_addoptrace = ON;   -- 追踪操作码添加
PRAGMA vdbe_addoptrace = OFF;  -- 默认
```

## 九、元数据查询

### table_info — 表结构信息

```sql
PRAGMA table_info('users');
-- 返回: cid, name, type, notnull, dflt_value, pk
```

### table_xinfo — 扩展表信息

```sql
PRAGMA table_xinfo('users');
-- 包含隐藏列（如 WITHOUT ROWID 表的主键）
```

### index_info — 索引信息

```sql
PRAGMA index_info('idx_users_name');
-- 返回: seqno, cid, name
```

### index_list — 表的索引列表

```sql
PRAGMA index_list('users');
-- 返回: seq, name, unique, origin, partial
```

### index_xinfo — 扩展索引信息

```sql
PRAGMA index_xinfo('idx_users_name');
-- 包含排序顺序和排序规则
```

### foreign_key_list — 外键信息

```sql
PRAGMA foreign_key_list('orders');
-- 返回: id, seq, table, from, to, on_update, on_delete, match
```

### collation_list — 排序规则列表

```sql
PRAGMA collation_list;
-- 返回: seq, name
```

### function_list — 函数列表

```sql
PRAGMA function_list;
-- 返回所有可用函数
```

### module_list — 模块列表

```sql
PRAGMA module_list;
-- 返回所有虚拟表模块
```

### database_list — 数据库列表

```sql
PRAGMA database_list;
-- 返回: seq, name, file
```

### compile_options — 编译选项

```sql
PRAGMA compile_options;
-- 返回编译 SQLite 时使用的所有选项
```

### pragma_list — PRAGMA 列表

```sql
PRAGMA pragma_list;
-- 返回所有可用的 PRAGMA 名称
```

## 十、版本与状态

### schema_version — 模式版本

```sql
PRAGMA schema_version;       -- 查询
PRAGMA schema_version = 5;   -- 设置（通常由 SQLite 自动管理）
```

### user_version — 用户版本

用于应用自己的版本控制：

```sql
PRAGMA user_version;         -- 查询
PRAGMA user_version = 3;     -- 设置（应用自行管理）
```

### data_version — 数据版本

检测数据库是否被其他连接修改：

```sql
PRAGMA data_version;
-- 每次数据库修改后递增，可用于缓存失效检测
```

### application_id — 应用标识

```sql
PRAGMA application_id;           -- 查询
PRAGMA application_id = 12345;   -- 设置（用于文件类型识别）
```

## 十一、线程与并发配置

### threads — 辅助线程数

```sql
PRAGMA threads;          -- 查询
PRAGMA threads = 4;      -- 设置 SQLite 可使用的辅助线程数
```

### read_uncommitted — 读未提交

```sql
PRAGMA read_uncommitted = ON;   -- 允许脏读（仅 WAL 模式有效）
PRAGMA read_uncommitted = OFF;  -- 默认，禁止脏读
```

### recursive_triggers — 递归触发器

```sql
PRAGMA recursive_triggers = ON;   -- 允许触发器递归触发
PRAGMA recursive_triggers = OFF;  -- 默认，禁止递归
```

## 十二、安全相关配置

### trusted_schema — 可信模式

```sql
PRAGMA trusted_schema = ON;   -- 默认，允许虚拟表和函数
PRAGMA trusted_schema = OFF;  -- 安全模式，限制某些操作
```

### writable_schema — 可写模式

```sql
PRAGMA writable_schema = ON;   -- 允许修改 sqlite_schema 表（危险！）
PRAGMA writable_schema = OFF;  -- 默认
```

> **警告**：writable_schema = ON 非常危险，仅在修复损坏数据库时使用。

## 十三、内存管理

### soft_heap_limit — 软堆限制

```sql
PRAGMA soft_heap_limit = 268435456;  -- 256MB 软限制
PRAGMA soft_heap_limit = 0;           -- 无限制
```

### hard_heap_limit — 硬堆限制

```sql
PRAGMA hard_heap_limit = 536870912;  -- 512MB 硬限制
```

### shrink_memory — 释放内存

```sql
PRAGMA shrink_memory;  -- 尝试释放未使用的内存
```

## 十四、WAL 模式专用配置

### wal_autocheckpoint — 自动检查点

```sql
PRAGMA wal_autocheckpoint;       -- 查询
PRAGMA wal_autocheckpoint = 1000; -- 每 1000 页自动检查点
PRAGMA wal_autocheckpoint = 0;    -- 禁用自动检查点
```

### wal_checkpoint — 手动检查点

```sql
PRAGMA wal_checkpoint;           -- 默认检查点
PRAGMA wal_checkpoint(PASSIVE);  -- 被动检查点（不等待）
PRAGMA wal_checkpoint(FULL);     -- 完全检查点（等待读取者）
PRAGMA wal_checkpoint(RESTART);  -- 重启检查点（阻塞写入）
PRAGMA wal_checkpoint(TRUNCATE); -- 截断检查点（清空 WAL 文件）
```

### checkpoint_fullfsync — 检查点完全同步

```sql
PRAGMA checkpoint_fullfsync = ON;   -- 检查点时完全同步
PRAGMA checkpoint_fullfsync = OFF;  -- 默认
```

## 十五、实际调优配置模板

### 模板一：高性能读取场景

```sql
-- WAL 模式，读写并发
PRAGMA journal_mode = WAL;

-- 降低同步级别（可接受少量数据丢失风险）
PRAGMA synchronous = NORMAL;

-- 大缓存
PRAGMA cache_size = -32768;  -- 32MB

-- 启用内存映射
PRAGMA mmap_size = 268435456;  -- 256MB

-- 大页大小
PRAGMA page_size = 8192;

-- 启用外键
PRAGMA foreign_keys = ON;

-- 设置忙等待
PRAGMA busy_timeout = 5000;
```

### 模板二：高安全性场景

```sql
-- 完全同步
PRAGMA synchronous = FULL;

-- 安全删除
PRAGMA secure_delete = ON;

-- 启用外键
PRAGMA foreign_keys = ON;

-- 启用检查约束
PRAGMA ignore_check_constraints = OFF;

-- 定期完整性检查
PRAGMA integrity_check;
```

### 模板三：批量导入优化

```sql
-- 开始导入前
PRAGMA journal_mode = MEMORY;    -- 日志存内存
PRAGMA synchronous = OFF;         -- 不同步
PRAGMA foreign_keys = OFF;        -- 禁用外键检查
PRAGMA locking_mode = EXCLUSIVE;  -- 独占锁

-- ... 执行大量 INSERT ...

-- 导入完成后恢复
PRAGMA journal_mode = WAL;
PRAGMA synchronous = FULL;
PRAGMA foreign_keys = ON;
PRAGMA locking_mode = NORMAL;

-- 优化查询计划
PRAGMA optimize;

-- 分析表
ANALYZE;
```

### 模板四：嵌入式设备优化

```sql
-- 小缓存（内存有限）
PRAGMA cache_size = -1024;  -- 1MB

-- 禁用内存映射（避免虚拟内存问题）
PRAGMA mmap_size = 0;

-- 小页大小
PRAGMA page_size = 1024;

-- 增量自动清理
PRAGMA auto_vacuum = INCREMENTAL;

-- 限制数据库大小
PRAGMA max_page_count = 100000;
```

## 十六、C++ 中的 PRAGMA 使用

```cpp
#include <sqlite3.h>
#include <iostream>
#include <string>
#include <map>

class SQLiteConfig {
public:
    enum class Mode {
        SPEED,      // 高性能
        SAFETY,     // 高安全
        BALANCED    // 平衡（默认）
    };

    static bool optimize_connection(sqlite3* db, Mode mode = Mode::BALANCED) {
        std::map<std::string, std::string> config;
        
        switch (mode) {
            case Mode::SPEED:
                config = {
                    {"journal_mode", "WAL"},
                    {"synchronous", "NORMAL"},
                    {"cache_size", "-32768"},
                    {"mmap_size", "268435456"},
                    {"temp_store", "MEMORY"}
                };
                break;
                
            case Mode::SAFETY:
                config = {
                    {"journal_mode", "DELETE"},
                    {"synchronous", "FULL"},
                    {"secure_delete", "ON"}
                };
                break;
                
            case Mode::BALANCED:
            default:
                config = {
                    {"journal_mode", "WAL"},
                    {"synchronous", "FULL"},
                    {"cache_size", "-8192"},
                    {"foreign_keys", "ON"},
                    {"busy_timeout", "5000"}
                };
                break;
        }
        
        // 执行 PRAGMA 设置
        for (const auto& [pragma, value] : config) {
            std::string sql = "PRAGMA " + pragma + " = " + value;
            char* err_msg = nullptr;
            
            int rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);
            if (rc != SQLITE_OK) {
                std::cerr << "PRAGMA " << pragma << " failed: " 
                          << err_msg << std::endl;
                sqlite3_free(err_msg);
                return false;
            }
            
            // 验证设置
            std::string verify_sql = "PRAGMA " + pragma;
            sqlite3_stmt* stmt;
            rc = sqlite3_prepare_v2(db, verify_sql.c_str(), -1, &stmt, nullptr);
            if (rc == SQLITE_OK && sqlite3_step(stmt) == SQLITE_ROW) {
                const char* actual = reinterpret_cast<const char*>(
                    sqlite3_column_text(stmt, 0)
                );
                std::cout << "PRAGMA " << pragma << " = " 
                          << (actual ? actual : "NULL") << std::endl;
            }
            sqlite3_finalize(stmt);
        }
        
        return true;
    }
    
    static bool set_pragma(sqlite3* db, const std::string& pragma, 
                           const std::string& value) {
        std::string sql = "PRAGMA " + pragma + " = " + value;
        char* err_msg = nullptr;
        
        int rc = sqlite3_exec(db, sql.c_str(), nullptr, nullptr, &err_msg);
        if (rc != SQLITE_OK) {
            std::cerr << "Error: " << err_msg << std::endl;
            sqlite3_free(err_msg);
            return false;
        }
        return true;
    }
    
    static std::string get_pragma(sqlite3* db, const std::string& pragma) {
        std::string sql = "PRAGMA " + pragma;
        sqlite3_stmt* stmt;
        std::string result;
        
        int rc = sqlite3_prepare_v2(db, sql.c_str(), -1, &stmt, nullptr);
        if (rc == SQLITE_OK && sqlite3_step(stmt) == SQLITE_ROW) {
            const char* text = reinterpret_cast<const char*>(
                sqlite3_column_text(stmt, 0)
            );
            if (text) result = text;
        }
        sqlite3_finalize(stmt);
        return result;
    }
};

// 使用示例
int main() {
    sqlite3* db;
    
    // 打开数据库（Serialized 模式，线程安全）
    int flags = SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE 
                | SQLITE_OPEN_FULLMUTEX;
    int rc = sqlite3_open_v2("app.db", &db, flags, nullptr);
    
    if (rc != SQLITE_OK) {
        std::cerr << "Cannot open database: " << sqlite3_errmsg(db) << std::endl;
        sqlite3_close(db);
        return 1;
    }
    
    // 应用平衡模式配置
    if (!SQLiteConfig::optimize_connection(db, SQLiteConfig::Mode::BALANCED)) {
        std::cerr << "Failed to optimize connection" << std::endl;
    }
    
    // 单独设置某个 PRAGMA
    SQLiteConfig::set_pragma(db, "busy_timeout", "10000");
    
    // 查询当前值
    std::string journal_mode = SQLiteConfig::get_pragma(db, "journal_mode");
    std::cout << "Current journal_mode: " << journal_mode << std::endl;
    
    // 使用数据库...
    const char* sql = "CREATE TABLE IF NOT EXISTS users ("
                      "id INTEGER PRIMARY KEY, "
                      "name TEXT NOT NULL)";
    char* err_msg = nullptr;
    rc = sqlite3_exec(db, sql, nullptr, nullptr, &err_msg);
    if (rc != SQLITE_OK) {
        std::cerr << "SQL error: " << err_msg << std::endl;
        sqlite3_free(err_msg);
    }
    
    // 批量导入优化示例
    void optimize_for_bulk_insert(sqlite3* db) {
        SQLiteConfig::set_pragma(db, "journal_mode", "MEMORY");
        SQLiteConfig::set_pragma(db, "synchronous", "OFF");
        SQLiteConfig::set_pragma(db, "foreign_keys", "OFF");
        SQLiteConfig::set_pragma(db, "locking_mode", "EXCLUSIVE");
    }
    
    void restore_after_bulk_insert(sqlite3* db) {
        SQLiteConfig::set_pragma(db, "journal_mode", "WAL");
        SQLiteConfig::set_pragma(db, "synchronous", "FULL");
        SQLiteConfig::set_pragma(db, "foreign_keys", "ON");
        SQLiteConfig::set_pragma(db, "locking_mode", "NORMAL");
        sqlite3_exec(db, "PRAGMA optimize", nullptr, nullptr, nullptr);
    }
    
    sqlite3_close(db);
    return 0;
}
```

**编译命令**：
```bash
g++ -std=c++17 sqlite_config.cpp -lsqlite3 -o sqlite_config
```

## 十七、PRAGMA 速查表

| PRAGMA | 类型 | 用途 | 常用值 |
|--------|------|------|--------|
| `journal_mode` | 设置 | 日志模式 | WAL, DELETE |
| `synchronous` | 设置 | 同步级别 | FULL, NORMAL, OFF |
| `cache_size` | 设置 | 缓存大小 | -8192, -32768 |
| `page_size` | 设置 | 页大小 | 4096, 8192 |
| `mmap_size` | 设置 | 内存映射 | 0, 268435456 |
| `temp_store` | 设置 | 临时存储 | MEMORY, FILE |
| `foreign_keys` | 设置 | 外键约束 | ON, OFF |
| `busy_timeout` | 设置 | 忙等待 | 5000 |
| `wal_autocheckpoint` | 设置 | WAL 检查点 | 1000 |
| `auto_vacuum` | 设置 | 自动清理 | NONE, INCREMENTAL |
| `locking_mode` | 设置 | 锁定模式 | NORMAL, EXCLUSIVE |
| `secure_delete` | 设置 | 安全删除 | ON, OFF |
| `query_only` | 设置 | 只读模式 | ON, OFF |
| `threads` | 设置 | 辅助线程 | 4 |
| `analysis_limit` | 设置 | 分析限制 | 1000 |
| `encoding` | 设置 | 编码 | UTF-8 |
| `integrity_check` | 查询 | 完整性检查 | - |
| `quick_check` | 查询 | 快速检查 | - |
| `table_info` | 查询 | 表结构 | 表名 |
| `index_list` | 查询 | 索引列表 | 表名 |
| `foreign_key_list` | 查询 | 外键信息 | 表名 |
| `compile_options` | 查询 | 编译选项 | - |
| `database_list` | 查询 | 数据库列表 | - |
| `freelist_count` | 查询 | 空闲页数 | - |
| `page_count` | 查询 | 总页数 | - |
| `user_version` | 设置/查询 | 用户版本 | 整数 |
| `schema_version` | 设置/查询 | 模式版本 | 整数 |
| `data_version` | 查询 | 数据版本 | - |
| `application_id` | 设置/查询 | 应用标识 | 整数 |
| `optimize` | 执行 | 优化查询 | - |
| `shrink_memory` | 执行 | 释放内存 | - |
| `incremental_vacuum` | 执行 | 增量清理 | 页数 |
| `wal_checkpoint` | 执行 | WAL 检查点 | PASSIVE, FULL, RESTART, TRUNCATE |

## 总结

SQLite 的 PRAGMA 系统提供了极其丰富的配置能力，从基础的日志模式到高级的内存管理，从查询优化到数据完整性检查，几乎覆盖了数据库运行的方方面面。

掌握这些配置参数，能够让你：
- **提升性能**：通过 WAL、缓存、内存映射等优化
- **保障安全**：通过同步级别、安全删除、完整性检查等
- **精细控制**：通过外键、约束、锁定模式等
- **诊断问题**：通过各种调试和追踪 PRAGMA

建议根据实际应用场景，选择合适的配置模板，并在关键参数上进行基准测试，找到性能与安全的最佳平衡点。
