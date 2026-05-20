---
title: 'Git: 利用Git的subtree功能在不同工程共享代码'
id: 156
categories:
  - Git
  - 版本控制
tags:
  - git
  - subtree
  - 代码共享
abbrlink: 278d
date: 2016-03-05 10:26:27
comments: true
---

# Git Subtree：在不同项目间共享代码

在软件开发中，我们经常需要在多个项目之间共享代码。常见的场景包括：

- 多个项目共用一个公共类库
- 将一个大型仓库拆分成多个独立仓库
- 维护第三方依赖库的定制版本
- 在不fork的情况下贡献代码

Git提供了两种主要的代码共享方案：**Git Subtree** 和 **Git Submodule**。本文将详细介绍Git Subtree的使用方法、适用场景以及最佳实践。

## Subtree vs Submodule：如何选择

在选择之前，我们需要了解两者的区别：

| 特性 | Subtree | Submodule |
|------|---------|-----------|
| 克隆行为 | 完整代码 | 仅引用（指针） |
| 学习曲线 | 简单 | 较复杂 |
| 依赖管理 | 自动包含 | 需要单独操作 |
| 历史记录 | 合并后无独立历史 | 保持独立历史 |
| 远程更新 | `git subtree pull` | `git submodule update` |
| 代码推送 | `git subtree push` | 直接推送不被推荐 |
| 依赖版本 | 锁定在特定commit | 可选择分支 |

### 选择建议

- **选择Subtree**：代码改动较多，需要在主项目和子项目之间双向同步
- **选择Submodule**：只读依赖，依赖库由专人维护，只需要定时更新

---

## 一、第一次添加子目录，建立与远程仓库的关联

### 操作步骤

添加Subtree需要两条命令：

#### 1. 添加远程仓库

```bash
git remote add -f <子仓库名> <子仓库地址>
```

参数说明：
- `-f`：在添加远程仓库后，立即执行fetch获取远程仓库信息

#### 2. 创建Subtree

```bash
git subtree add --prefix=<子目录名> <子仓库名> <分支> --squash
```

参数说明：
- `--prefix=<子目录名>`：指定在主项目中存放代码的目录名称
- `<子仓库名>`：远程仓库的别名（上面添加的名称）
- `<分支>`：要拉取的分支，通常是 `master` 或 `main`
- `--squash`：将subtree的改动合并成一次commit，避免带入完整的历史记录

### 完整示例

```bash
# 1. 添加远程仓库
$ git remote add -f ai https://github.com/aoxu/ai.git

# 2. 创建subtree
$ git subtree add --prefix=ai ai master --squash
```

执行成功后，远程仓库 `ai` 的代码会被克隆到主项目的 `ai/` 目录下。

### 命令解析

```bash
# 添加远程仓库并立即fetch
git remote add -f ai https://github.com/aoxu/ai.git

# 命令解析：
# git remote add      - 添加远程仓库
# -f                   - 添加后立即执行fetch
# ai                   - 远程仓库的别名
# https://github.com/aoxu/ai.git  - 远程仓库地址

# 创建subtree
git subtree add --prefix=ai ai master --squash

# 命令解析：
# git subtree add      - 创建subtree
# --prefix=ai          - 在ai目录下存放
# ai                   - 使用名为ai的远程仓库
# master               - 拉取master分支
# --squash             - 合并历史，避免污染主项目
```

---

## 二、从远程仓库更新子目录

当子仓库有更新时，我们需要将更新同步到主项目中。

### 操作步骤

```bash
# 1. 获取远程仓库的最新内容
git fetch <远程仓库名> <分支>

# 2. 合并更新到本地subtree
git subtree pull --prefix=<子目录名> <远程仓库名> <分支> --squash
```

### 完整示例

```bash
# 1. 获取远程更新
$ git fetch ai master

# 2. 合并到本地subtree
$ git subtree pull --prefix=ai ai master --squash
```

### 命令解析

```bash
git fetch ai master
# 从ai仓库获取master分支的最新代码

git subtree pull --prefix=ai ai master --squash
# --prefix=ai          - 更新ai目录
# ai                   - 使用ai远程仓库
# master               - 拉取master分支
# --squash             - 合并历史
```

### 简化写法

实际上，由于远程仓库信息已保存，可以简化为：

```bash
git subtree pull --prefix=ai ai master --squash
```

---

## 三、向远程仓库推送子目录的改动

如果我们在子目录中做了修改，并希望将这些改动同步回远程仓库（确认你有写权限）。

### 操作步骤

```bash
git subtree push --prefix=<子目录名> <远程分支名> <分支>
```

### 完整示例

```bash
$ git subtree push --prefix=ai ai master
```

### 命令解析

```bash
git subtree push --prefix=ai ai master
# --prefix=ai          - 推送ai目录的内容
# ai                   - 推送到ai远程仓库
# master               - 推送到master分支
```

### 注意事项

1. **确认写权限**：推送前请确认你对远程仓库有写权限
2. **先pull再push**：建议在push之前先执行pull，确保版本一致
3. **检查改动**：使用 `git status` 和 `git diff` 检查要推送的改动

```bash
# 推荐的操作流程
$ cd ai
$ git add .
$ git commit -m "update submodule"
$ cd ..
$ git subtree pull --prefix=ai ai master --squash
$ git subtree push --prefix=ai ai master
```

---

## 四、高级用法

### 1. 指定不同的分支

Subtree支持使用任何分支，不一定是 `master`：

```bash
# 添加develop分支
git subtree add --prefix=ai ai develop --squash

# 更新到develop分支
git subtree pull --prefix=ai ai develop --squash

# 推送到develop分支
git subtree push --prefix=ai ai develop
```

### 2. 不使用squash保留完整历史

如果不使用 `--squash`，subtree会保留完整的子项目历史：

```bash
git subtree add --prefix=ai ai master
git subtree pull --prefix=ai ai master
```

**注意**：这会导致主项目的历史包含子项目的完整历史，可能造成污染。

### 3. 重新关联到不同的仓库

如果需要将subtree关联到新的远程仓库：

```bash
# 1. 修改远程仓库地址
git remote set-url ai https://github.com/newuser/newrepo.git

# 2. 重新fetch
git fetch ai master

# 3. 重新创建subtree关联
git subtree add --prefix=ai ai master --squash
```

### 4. 拆分现有目录为Subtree

如果想把主项目中的一个现有目录拆分出来作为独立的subtree：

```bash
# 将common目录拆分到新的远程仓库
git subtree split --prefix=common -b common-branch
git remote add -f common <new-repo-url>
git subtree push --prefix=common common common-branch
```

---

## 五、常见问题与解决方案

### 问题1：Subtree push失败

**错误信息**：
```
fatal: '/path/to/repo' does not have a commit linked to this remote commit
```

**解决方案**：先pull再push

```bash
git subtree pull --prefix=ai ai master --squash
git subtree push --prefix=ai ai master
```

### 问题2：如何完全移除Subtree

如果不再需要subtree：

```bash
# 1. 删除subtree目录
$ rm -rf ai

# 2. 从git中移除
$ git rm --cached ai
$ git commit -m "Remove subtree"

# 3. 可选：移除远程仓库关联
$ git remote remove ai
```

### 问题3：subtree目录下的文件无法提交

**原因**：subtree目录需要用subtree命令操作，不能直接在子目录内git操作

**解决方案**：

```bash
# 正确的方式
git add ai/
git commit -m "update subtree"

# 或者直接用subtree命令
git subtree push --prefix=ai ai master
```

### 问题4：Submodule和Subtree混淆

**区别**：
- Submodule：子目录是一个链接（commit引用），显示为 `xxx (某commit)`
- Subtree：子目录是实际代码，显示为正常的文件

**检查方法**：

```bash
# 检查是否是submodule
$ cat .gitmodules
# 如果有内容，说明是submodule

# 检查subtree
$ git log --oneline
# 会看到subtree的merge commit
```

---

## 六、最佳实践

### 1. 统一的命名规范

```bash
# 推荐：使用统一的子目录名称
git subtree add --prefix=libs/common ai master --squash
git subtree add --prefix=libs/utils utils master --squash

# 不推荐：混用不同的命名方式
git subtree add --prefix=ai ai master --squash
git subtree add --prefix=Utils Utils master --squash
```

### 2. 定期同步更新

建议制定更新时间表，比如每周或每月更新一次：

```bash
# 更新脚本 update-subtrees.sh
#!/bin/bash

echo "Updating subtrees..."

# 更新common库
git subtree pull --prefix=libs/common common master --squash

# 更新utils库
git subtree pull --prefix=libs/utils utils master --squash

echo "Update complete!"
git status
```

### 3. 提交规范

在subtree相关的commit中使用清晰的message：

```bash
git commit -m "[subtree] Update ai library to latest version"
git commit -m "[subtree] Sync utils changes to remote"
```

### 4. CI/CD集成

在自动化流程中处理subtree：

```yaml
# .gitlab-ci.yml 示例
stages:
  - build

update-subtree:
  stage: build
  script:
    - git subtree pull --prefix=libs/common common master --squash
    - git push
  only:
    - master
```

---

## 七、实战场景

### 场景1：团队共享公共类库

**背景**：A项目、B项目都需要使用同一个公共类库 `common-lib`

**解决方案**：

```bash
# 在A项目中添加subtree
$ git remote add -f common-lib git@github.com:team/common-lib.git
$ git subtree add --prefix=libs/common-lib common-lib master --squash

# A项目修改后推送到远程
$ cd libs/common-lib
$ git add .
$ git commit -m "fix: update API"
$ cd ../..
$ git subtree push --prefix=libs/common-lib common-lib master

# B项目同步更新
$ git subtree pull --prefix=libs/common-lib common-lib master --squash
```

### 场景2：管理第三方依赖的定制版本

**背景**：需要使用第三方库，但需要一些定制修改

```bash
# 添加第三方库作为subtree
$ git remote add -f third-party git@github.com:vendor/their-lib.git
$ git subtree add --prefix=vendor/their-lib third-party v1.2.3 --squash

# 做定制修改
$ cd vendor/their-lib
$ git checkout -b custom-features
# 进行修改...
$ git commit -m "custom: add our features"
$ cd ../..
$ git subtree push --prefix=vendor/their-lib third-party custom-features
```

### 场景3：仓库拆分

**背景**：将大型仓库中的某个目录拆分成独立仓库

```bash
# 在原仓库中
$ git subtree split --prefix=old-modules/logger -b logger-split

# 创建新仓库
$ git push git@github.com:new/repo.git logger-split:master

# 在新仓库中使用
$ git remote add -f logger git@github.com:new/repo.git
$ git subtree add --prefix=modules/logger logger master --squash
```

---

## 八、命令速查表

| 操作 | 命令 |
|------|------|
| 添加subtree | `git subtree add --prefix=<目录> <远程名> <分支> --squash` |
| 更新subtree | `git subtree pull --prefix=<目录> <远程名> <分支> --squash` |
| 推送subtree | `git subtree push --prefix=<目录> <远程名> <分支>` |
| 拆分目录为subtree | `git subtree split --prefix=<目录> -b <分支>` |
| 移除subtree | `rm -rf <目录> && git rm --cached <目录>` |

---

## 总结

Git Subtree是一个强大的代码共享工具，它通过合并而非链接的方式在项目间共享代码。相较于Submodule，Subtree更加简单直接，特别适合需要双向同步代码的场景。

**选择Subtree的三大理由**：

1. **简单易用**：无需了解复杂的 submodule 命令
2. **代码完整**：子项目代码直接包含在主项目中
3. **灵活同步**：支持双向同步，既能拉取更新也能推送改动

掌握Git Subtree，让你的代码复用更加高效！
    
