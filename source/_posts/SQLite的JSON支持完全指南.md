---
title: SQLite 的 JSON 支持完全指南
date: 2026-06-03 11:00:00
tags:
  - SQLite
  - JSON
  - 数据库
categories:
  - 数据库
---

## 前言

SQLite 作为全球最流行的嵌入式数据库，早已不只是处理结构化数据的工具。从 3.38.0 版本开始，JSON 支持成为**内置功能**（之前是可选扩展），提供了完整的 JSON 解析、查询、修改和验证能力。更令人惊喜的是，3.45.0 版本引入了 **JSONB 二进制格式**，大幅提升了 JSON 处理性能。

本文将系统梳理 SQLite 对 JSON 的支持能力，帮助你全面掌握这一强大特性。

## JSON 支持的演进

| 版本 | 日期 | 变更 |
|------|------|------|
| 3.9.0 | 2015-10 | 首次引入 JSON1 扩展（需编译选项启用） |
| 3.38.0 | 2022-02 | JSON 函数**内置**，默认启用 |
| 3.42.0 | 2023-05 | 支持 JSON5 扩展语法读取 |
| 3.45.0 | 2024-01 | 引入 JSONB 二进制存储格式 |
| 3.47.0 | 2024-11 | JSON 函数扩容，性能优化 |
| 3.51.0 | 2025 | JSONB 函数进一步完善 |

## 核心概念

### 存储方式

SQLite 将 JSON 存储为**普通文本（TEXT）**，不支持独立的 JSON 类型（这是向后兼容性约束）。从 3.45.0 开始，还可以存储为 **JSONB（BLOB）** 二进制格式，性能更高、占用空间更小。

```sql
-- 文本格式存储
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    profile TEXT  -- JSON 文本
);

-- JSONB 格式存储（3.45.0+）
CREATE TABLE users_jsonb (
    id INTEGER PRIMARY KEY,
    name TEXT,
    profile BLOB  -- JSONB 二进制
);
```

### JSONB vs TEXT JSON

| 特性 | TEXT JSON | JSONB |
|------|-----------|-------|
| 存储类型 | TEXT | BLOB |
| 读取时解析 | 每次都需要解析 | 无需解析，直接使用 |
| 写入时渲染 | 需要渲染为文本 | 无需渲染 |
| 磁盘空间 | 较大 | 较小（约节省 10-20%） |
| 查询性能 | 基准 | 快 2-5 倍 |
| 可读性 | 人类可读 | 二进制，不可读 |
| 最低版本 | 3.9.0 | 3.45.0 |

> **注意**：SQLite 的 JSONB 格式与 PostgreSQL 的 JSONB **不兼容**，虽然名称相同，但二进制格式不同。

## JSON 函数分类

SQLite 提供了 **30 个函数 + 2 个运算符 + 4 个表值函数 + 4 个聚合函数**，全面覆盖 JSON 操作需求。

### 一、创建 JSON

#### json() / jsonb()

验证并规范化 JSON 字符串，输出为标准 JSON 格式：

```sql
-- 规范化 JSON（自动去除多余空格）
SELECT json('  { "name" : "Alice" , "age" : 30 }  ');
-- 输出: {"name":"Alice","age":30}

-- JSON5 语法也可以解析（3.42.0+）
SELECT json("{name: 'Alice', age: 30,}");
-- 输出: {"name":"Alice","age":30}

-- jsonb() 输出二进制格式
SELECT jsonb('{"name":"Alice","age":30}');
```

#### json_array() / jsonb_array()

创建 JSON 数组：

```sql
SELECT json_array(1, 'hello', NULL, 3.14, true, json('{"x":1}'));
-- 输出: [1,"hello",null,3.14,true,{"x":1}]
```

#### json_object() / jsonb_object()

创建 JSON 对象：

```sql
SELECT json_object('name', 'Alice', 'age', 30, 'city', 'Beijing');
-- 输出: {"name":"Alice","age":30,"city":"Beijing"}
```

### 二、提取数据

#### json_extract() / jsonb_extract()

使用路径表达式提取 JSON 中的值：

```sql
SELECT json_extract('{"name":"Alice","scores":[90,85,92]}', '$.name');
-- 输出: "Alice"

SELECT json_extract('{"name":"Alice","scores":[90,85,92]}', '$.scores[0]');
-- 输出: 90

SELECT json_extract('{"name":"Alice","scores":[90,85,92]}', '$.scores[#-1]');
-- 输出: 92（最后一个元素）
```

#### -> 和 ->> 运算符

`->` 提取 JSON 元素（保留 JSON 类型），`->>` 提取为 TEXT：

```sql
-- -> 保留 JSON 类型
SELECT '{"name":"Alice"}' -> '$.name';
-- 输出: "Alice"（带引号的 JSON 字符串）

-- ->> 提取为纯文本
SELECT '{"name":"Alice"}' ->> '$.name';
-- 输出: Alice（不带引号）

-- 实际查询示例
SELECT name, profile ->> '$.address.city' AS city
FROM users
WHERE profile ->> '$.role' = 'admin';
```

### 三、修改 JSON

#### json_set() / json_insert() / json_replace()

| 函数 | 行为 |
|------|------|
| `json_set()` | 存在则替换，不存在则插入 |
| `json_insert()` | 仅在路径不存在时插入 |
| `json_replace()` | 仅在路径存在时替换 |

```sql
-- json_set：存在则替换，不存在则新增
SELECT json_set('{"name":"Alice","age":30}', '$.age', 31, '$.city', 'Shanghai');
-- 输出: {"name":"Alice","age":31,"city":"Shanghai"}

-- json_insert：仅在不存在时插入
SELECT json_insert('{"name":"Alice"}', '$.age', 30, '$.name', 'Bob');
-- 输出: {"name":"Alice","age":30}（name 已存在，不修改）

-- json_replace：仅在存在时替换
SELECT json_replace('{"name":"Alice","age":30}', '$.age', 31, '$.city', 'Shanghai');
-- 输出: {"name":"Alice","age":31}（city 不存在，不新增）
```

#### json_remove()

删除指定路径的元素：

```sql
SELECT json_remove('{"name":"Alice","age":30,"city":"Beijing"}', '$.city');
-- 输出: {"name":"Alice","age":30}
```

#### json_array_insert()

在数组指定位置插入元素：

```sql
SELECT json_array_insert('[1,2,3]', '$[1]', 'new');
-- 输出: [1,"new",2,3]
```

#### json_patch()

合并两个 JSON 对象（类似 RFC 7396 JSON Merge Patch）：

```sql
SELECT json_patch('{"a":1,"b":2}', '{"b":3,"c":4}');
-- 输出: {"a":1,"b":3,"c":4}
```

### 四、查询与遍历

#### json_each() / json_tree()

这两个**表值函数**可以将 JSON 拆解为行，用于 SQL 查询：

```sql
-- json_each()：遍历顶层元素
SELECT * FROM json_each('["apple","banana","cherry"]');
-- 输出:
-- key | value   | type | atom
-- 0   | "apple"  | text | apple
-- 1   | "banana" | text | banana
-- 2   | "cherry" | text | cherry

-- json_tree()：递归遍历所有层级
SELECT * FROM json_tree('{"name":"Alice","scores":[90,85]}');
-- 输出所有节点的完整路径树

-- 实际应用：查询 JSON 数组中的元素
SELECT value
FROM json_each(
    SELECT profile ->> '$.tags' FROM users WHERE id = 1
);
```

#### json_group_array() / json_group_object()

聚合函数，将多行数据聚合为 JSON：

```sql
-- 将多行聚合成 JSON 数组
SELECT json_group_array(name) FROM users;
-- 输出: ["Alice","Bob","Charlie"]

-- 将多行聚合成 JSON 对象
SELECT json_group_array(json_object('id', id, 'name', name))
FROM users WHERE age > 25;
-- 输出: [{"id":1,"name":"Alice"},{"id":3,"name":"Charlie"}]

-- json_group_object：键值对聚合
SELECT json_group_object(name, city) FROM users;
-- 输出: {"Alice":"Beijing","Bob":"Shanghai","Charlie":"Guangzhou"}
```

### 五、验证与检查

#### json_valid()

验证字符串是否为合法 JSON：

```sql
SELECT json_valid('{"name":"Alice"}');
-- 输出: 1（有效）

SELECT json_valid('{name:Alice}');
-- 输出: 0（标准 JSON 无效）

SELECT json_valid('{name:Alice}', 2);
-- 输出: 1（JSON5 有效，flags=2 启用 JSON5 检测）
```

#### json_type()

返回 JSON 值的类型：

```sql
SELECT json_type('{"name":"Alice","age":30}', '$.name');
-- 输出: text

SELECT json_type('{"name":"Alice","age":30}', '$.age');
-- 输出: integer

SELECT json_type('[1,2,3]');
-- 输出: array
```

#### json_array_length()

返回 JSON 数组的长度：

```sql
SELECT json_array_length('[1,2,3,4,5]');
-- 输出: 5

SELECT json_array_length('{"scores":{"math":90,"eng":85}}', '$.scores');
-- 输出: 2
```

#### json_error_position()

当 JSON 解析失败时，返回错误位置（3.45.0+）：

```sql
SELECT json_error_position('{"name":"Alice" age:30}');
-- 输出: 16（错误位置）
```

#### json_pretty()

格式化 JSON 输出：

```sql
SELECT json_pretty('{"name":"Alice","age":30,"scores":[90,85,92]}');
```

输出：
```json
{
  "name": "Alice",
  "age": 30,
  "scores": [
    90,
    85,
    92
  ]
}
```

#### json_quote()

将 SQL 值转换为带引号的 JSON 字符串：

```sql
SELECT json_quote('Hello "World"');
-- 输出: "Hello \"World\""
```

## 路径表达式语法

JSON 函数中的路径表达式（PATH）语法：

| 语法 | 说明 | 示例 |
|------|------|------|
| `$` | 根元素 | `$.name` |
| `.key` | 对象属性 | `$.address.city` |
| `[N]` | 数组索引（从 0 开始） | `$.scores[0]` |
| `[#-N]` | 从右数第 N 个 | `$.scores[#-1]`（最后一个） |
| `[#]` | 追加到数组末尾 | `$.scores[#]` |
| `.*` | 通配所有对象属性 | `$.*` |
| `[*]` | 通配所有数组元素 | `$.scores[*]` |

```sql
-- 通配符示例
SELECT json_extract('{"a":1,"b":2,"c":3}', '$.*');
-- 输出: [1,2,3]

SELECT json_extract('{"scores":[90,85,92]}', '$.scores[*]');
-- 输出: [90,85,92]
```

## 实战应用场景

### 场景一：用户配置存储

```sql
CREATE TABLE user_settings (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    settings TEXT NOT NULL,  -- JSON 格式
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 插入配置
INSERT INTO user_settings (user_id, settings) VALUES (
    1,
    json_object(
        'theme', 'dark',
        'language', 'zh-CN',
        'notifications', json_object(
            'email', true,
            'push', false,
            'sms', true
        ),
        'max_items', 50
    )
);

-- 查询特定配置项
SELECT settings ->> '$.theme' AS theme,
       settings ->> '$.notifications.email' AS email_notify
FROM user_settings
WHERE user_id = 1;

-- 修改单个配置项（不影响其他配置）
UPDATE user_settings
SET settings = json_set(settings, '$.theme', 'light')
WHERE user_id = 1;
```

### 场景二：日志存储与分析

```sql
CREATE TABLE logs (
    id INTEGER PRIMARY KEY,
    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    level TEXT,
    message TEXT,
    context TEXT  -- JSON 格式的上下文信息
);

-- 插入日志
INSERT INTO logs (level, message, context) VALUES (
    'ERROR',
    'Database connection failed',
    json_object(
        'host', 'db.example.com',
        'port', 5432,
        'error_code', 'ECONNREFUSED',
        'retry_count', 3,
        'tags', json_array('database', 'network')
    )
);

-- 查询包含特定标签的日志
SELECT timestamp, message, context ->> '$.error_code' AS error_code
FROM logs
WHERE context ->> '$.host' = 'db.example.com'
  AND json_array_length(context -> '$.tags') > 1;

-- 统计各级别日志数量，按标签分组
SELECT value AS tag, COUNT(*) AS count
FROM logs, json_each(context -> '$.tags')
GROUP BY tag;
```

### 场景三：灵活的产品属性

```sql
CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT,
    attributes TEXT  -- JSON 格式，不同类别有不同属性
);

-- 手机产品
INSERT INTO products (name, category, attributes) VALUES (
    'Pixel 9', 'phone',
    json_object(
        'brand', 'Google',
        'screen_size', 6.3,
        'storage_gb', 128,
        'colors', json_array('Obsidian', 'Porcelain', 'Bay'),
        'price', 799
    )
);

-- 书籍产品
INSERT INTO products (name, category, attributes) VALUES (
    'Designing Data-Intensive Applications', 'book',
    json_object(
        'author', 'Martin Kleppmann',
        'pages', 611,
        'isbn', '978-1449373320',
        'publisher', 'OReilly',
        'price', 45.99
    )
);

-- 查询所有手机的颜色选项
SELECT name, json_each.value AS color
FROM products, json_each(attributes -> '$.colors')
WHERE category = 'phone';

-- 查询价格在 50 到 100 之间的产品
SELECT name, category, attributes ->> '$.price' AS price
FROM products
WHERE CAST(attributes ->> '$.price' AS REAL) BETWEEN 50 AND 100;
```

### 场景四：使用 JSONB 提升性能

```sql
-- 创建 JSONB 格式表
CREATE TABLE events (
    id INTEGER PRIMARY KEY,
    event_type TEXT,
    payload BLOB,  -- JSONB 格式
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 插入时使用 jsonb() 转换
INSERT INTO events (event_type, payload) VALUES (
    'user_login',
    jsonb(json_object('user_id', 42, 'ip', '192.168.1.1', 'device', 'mobile'))
);

-- 查询时直接使用，无需额外转换
SELECT event_type,
       payload ->> '$.user_id' AS user_id,
       payload ->> '$.ip' AS ip
FROM events
WHERE event_type = 'user_login';
```

## 性能优化建议

### 1. 使用 JSONB 替代 TEXT JSON

```sql
-- 推荐：使用 jsonb_ 前缀函数链
SELECT json_extract(jsonb_set(jsonb(payload), '$.status', '"active"'), '$.updated_at')
FROM events;

-- 不推荐：使用 json_ 前缀函数链（需要反复解析/渲染）
SELECT json_extract(json_set(json(payload), '$.status', '"active"'), '$.updated_at')
FROM events;
```

### 2. 创建表达式索引

```sql
-- 对 JSON 字段中的常用查询路径创建索引
CREATE INDEX idx_users_role ON users(
    (json_extract(profile, '$.role'))
);

-- 查询时可以利用索引
SELECT * FROM users WHERE json_extract(profile, '$.role') = 'admin';
```

### 3. 避免过度嵌套

```sql
-- 不推荐：嵌套层级过深
json_extract(data, '$.level1.level2.level3.level4.level5')

-- 推荐：保持 2-3 层嵌套，或提取为独立列
```

### 4. 聚合函数使用 json_ 而非 jsonb_

```sql
-- 推荐：聚合函数用 json_ 前缀
SELECT json_group_array(json(payload)) FROM events;

-- 不推荐：聚合函数用 jsonb_ 前缀（反而更慢）
SELECT json_group_array(jsonb(payload)) FROM events;
```

## JSON5 扩展支持

从 3.42.0 开始，SQLite 可以读取 JSON5 格式的输入（但输出始终为标准 JSON）：

```sql
-- JSON5 允许：无引号键、尾逗号、单引号、注释等
SELECT json('{
    name: Alice,       // 无引号的键
    age: 30,           // 尾逗号
    "city": "Beijing",
    // 这是注释
    greeting: '\''hello world'\''
}');
-- 输出: {"name":"Alice","age":30,"city":"Beijing","greeting":"'hello world'"}
```

## 函数速查表

| 函数 | 用途 | 示例 |
|------|------|------|
| `json()` | 验证/规范化 JSON | `json('{a:1}')` |
| `jsonb()` | 转换为 JSONB | `jsonb('{"a":1}')` |
| `json_array()` | 创建数组 | `json_array(1,2,3)` |
| `json_object()` | 创建对象 | `json_object('a',1)` |
| `json_extract()` | 提取值 | `json_extract('{"a":1}','$')` |
| `->` | 提取（保留类型） | `'{"a":1}' -> '$.a'` |
| `->>` | 提取（转文本） | `'{"a":1}' ->> '$.a'` |
| `json_set()` | 设置值 | `json_set('{}','$.a',1)` |
| `json_insert()` | 插入值 | `json_insert('{}','$.a',1)` |
| `json_replace()` | 替换值 | `json_replace('{"a":1}','$.a',2)` |
| `json_remove()` | 删除值 | `json_remove('{"a":1}','$.a')` |
| `json_patch()` | 合并对象 | `json_patch('{}','{"a":1}')` |
| `json_array_insert()` | 数组插入 | `json_array_insert('[1]','$[1]',2)` |
| `json_type()` | 查看类型 | `json_type('1')` |
| `json_valid()` | 验证合法性 | `json_valid('{}')` |
| `json_array_length()` | 数组长度 | `json_array_length('[1,2]')` |
| `json_pretty()` | 格式化输出 | `json_pretty('{"a":1}')` |
| `json_quote()` | 转义为 JSON 字符串 | `json_quote('hello')` |
| `json_error_position()` | 错误位置 | `json_error_position('{a}')` |
| `json_each()` | 遍历顶层元素 | `SELECT * FROM json_each('[1,2]')` |
| `json_tree()` | 递归遍历所有 | `SELECT * FROM json_tree('{}')` |
| `json_group_array()` | 聚合为数组 | `json_group_array(name)` |
| `json_group_object()` | 聚合为对象 | `json_group_object(k,v)` |

## 总结

SQLite 的 JSON 支持已经非常成熟和全面：

| 能力 | 状态 |
|------|------|
| JSON 解析与创建 | ✅ 完整支持 |
| JSON 查询与提取 | ✅ 完整支持 |
| JSON 修改与合并 | ✅ 完整支持 |
| JSON 遍历（表值函数） | ✅ 完整支持 |
| JSON 聚合 | ✅ 完整支持 |
| JSONB 二进制格式 | ✅ 3.45.0+ |
| JSON5 扩展读取 | ✅ 3.42.0+ |
| 表达式索引优化 | ✅ 支持 |

对于嵌入式应用、移动端开发、本地配置存储等场景，SQLite 的 JSON 能力已经足够强大，在很多场景下可以替代 MongoDB 等文档数据库。如果你需要在轻量级环境中处理半结构化数据，SQLite + JSON 是一个非常实用的组合。
