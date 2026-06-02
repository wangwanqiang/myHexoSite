---
title: Git 提交规范：常用前缀缩写总结
tags:
  - git
  - 规范
categories:
  - Git
  - 版本控制
abbrlink: d721
date: 2026-06-03 10:00:00
---

## 前言

在团队协作开发中，规范的 Git 提交信息（Commit Message）至关重要。它不仅能帮助团队成员快速理解每次变更的目的，还能在自动化工具（如 CI/CD、Changelog 生成器）中发挥重要作用。

目前业界最广泛使用的是 **Conventional Commits**（约定式提交）规范，本文对其中的前缀缩写进行总结。

## Conventional Commits 格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

- **type**：提交类型（必填）
- **scope**：影响范围（可选）
- **subject**：简短描述（必填）
- **body**：详细描述（可选）
- **footer**：关联 Issue 或 Breaking Change（可选）

## 常用 type 前缀

| 缩写 | 全称 | 用途 | 示例 |
|------|------|------|------|
| `feat` | feature | 新功能 | `feat(user): 添加用户头像上传` |
| `fix` | bug fix | 修复 Bug | `fix(login): 修复登录超时问题` |
| `docs` | documentation | 文档变更 | `docs: 更新 README 安装说明` |
| `style` | style | 代码格式（不影响逻辑） | `style: 统一缩进为 2 空格` |
| `refactor` | refactor | 重构（非新功能、非修 Bug） | `refactor(api): 重构请求模块` |
| `perf` | performance | 性能优化 | `perf(db): 优化查询索引` |
| `test` | test | 添加或修改测试 | `test(user): 补充用户模块单测` |
| `build` | build | 构建系统或依赖变更 | `build: 升级 webpack 到 v5` |
| `ci` | ci | CI/CD 配置变更 | `ci: 添加 GitHub Actions 流水线` |
| `chore` | chore | 其他杂项（不涉及源码） | `chore: 更新 .gitignore` |
| `revert` | revert | 回滚之前的提交 | `revert: 回滚 feat(user) 提交` |

## 特殊标记

### Breaking Change（破坏性变更）

当提交包含不兼容的 API 变更时，有两种标记方式：

**方式一**：在 type 后加 `!`
```
feat(api)!: 修改用户接口返回格式

BREAKING CHANGE: 用户接口从返回数组改为返回分页对象
```

**方式二**：在 footer 中声明
```
feat(api): 修改用户接口返回格式

BREAKING CHANGE: 用户接口从返回数组改为返回分页对象
```

### 关联 Issue

在 footer 中关联相关 Issue：

```
fix(login): 修复登录超时问题

Closes #123
Refs #456
```

## scope 常见取值

scope 表示本次提交影响的模块或组件，常见的取值包括：

| scope | 含义 |
|-------|------|
| `core` | 核心模块 |
| `api` | API 接口 |
| `ui` | 界面/组件 |
| `db` | 数据库 |
| `auth` | 认证授权 |
| `config` | 配置文件 |
| `deps` | 依赖管理 |
| `docs` | 文档 |
| `ci` | 持续集成 |

## 实际项目示例

```bash
# 新功能
git commit -m "feat(user): 添加用户头像上传功能"

# 修复 Bug
git commit -m "fix(login): 修复 Token 过期未自动刷新"

# 文档更新
git commit -m "docs(api): 补充接口鉴权说明"

# 重构
git commit -m "refactor(utils): 将工具函数拆分为独立模块"

# 性能优化
git commit -m "perf(list): 列表渲染使用虚拟滚动"

# 破坏性变更
git commit -m "feat(api)!: 用户接口统一返回格式

BREAKING CHANGE: 所有接口响应结构从 { code, data, msg } 改为 { status, result, message }"

# 回滚
git commit -m "revert: revert feat(user) 添加用户头像上传功能"
```

## 自动化工具推荐

| 工具 | 用途 |
|------|------|
| `commitizen` | 交互式生成规范提交信息 |
| `cz-git` | commitizen 的中文适配器 |
| `husky` + `commitlint` | Git Hook 校验提交信息格式 |
| `standard-version` | 自动生成 Changelog |
| `conventional-changelog` | 根据提交历史生成变更日志 |

### commitizen 安装与使用

```bash
# 全局安装
npm install -g commitizen cz-conventional-changelog

# 初始化
commitizen init cz-conventional-changelog --save-dev --save-exact

# 使用（替代 git commit）
git cz
```

### commitlint 配置示例

```bash
# 安装
npm install -D @commitlint/cli @commitlint/config-conventional husky

# 配置 husky hook
npx husky add .husky/commit-msg 'npx commitlint --edit $1'
```

```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [2, 'always', [
      'feat', 'fix', 'docs', 'style', 'refactor',
      'perf', 'test', 'build', 'ci', 'chore', 'revert'
    ]],
    'subject-max-length': [2, 'always', 72],
  }
};
```

## 总结

| 要点 | 说明 |
|------|------|
| **格式** | `type(scope): subject` |
| **type 必填** | 从 11 种类型中选择最合适的 |
| **subject 简洁** | 不超过 72 字符，使用祈使句 |
| **scope 可选** | 明确影响范围，便于定位 |
| **Breaking Change** | 用 `!` 标记或在 footer 声明 |
| **关联 Issue** | 用 `Closes` / `Refs` 关联 |

坚持使用规范的提交信息，是对团队和未来自己的最好投资。
