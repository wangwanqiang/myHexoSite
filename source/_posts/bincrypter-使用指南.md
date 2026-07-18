---
title: bincrypter — Linux 二进制与脚本运行时加密工具
tags:
  - Linux
  - 加密
  - 安全
  - 代码保护
  - ELF
categories:
  - Linux
abbrlink: f3a1
date: 2026-07-17 22:00:00
updated: 2026-07-17 22:00:00
comments: true
---

`bincrypter` 是由 [THC (The Hackers Choice)](https://github.com/hackerschoice) 团队开源的轻量级二进制运行时加密/混淆工具。它能够对 ELF 可执行文件和 Shell 脚本进行加密、混淆和压缩，且**完全在内存中运行**，不落盘临时文件。

项目地址：<https://github.com/hackerschoice/bincrypter>

<!-- more -->

## 一、什么是 bincrypter？

`bincrypter` 是一个**纯 Bash 脚本**实现的运行时加密器。它通过以下方式保护你的程序：

1. **压缩** — 使用 gzip 压缩原始程序
2. **混淆** — 对解密存根（stub）和数据进行重编码，`strings` 只能看到乱码
3. **加密** — 使用 OpenSSL AES-256-CBC 对程序进行对称加密
4. **运行时解密** — 加密后的程序执行时，在内存中自动解密并执行，**不在磁盘上留下明文痕迹**

它的核心理念是 **Living off the Land（LotL）**——仅依赖系统自带的 `/bin/sh`、`perl` 和 `openssl`，无需安装任何额外运行时。

| 属性 | 说明 |
|------|------|
| 开发方 | [THC (The Hackers Choice)](https://thc.org) |
| 许可证 | GPL v2+ |
| 语言 | Bash (单文件脚本) |
| 依赖 | `/bin/sh` + `perl` + `openssl` |
| 支持架构 | x86_64、aarch64、arm6、mips 等（与架构无关） |
| 输出格式 | 自解密的 Shell 脚本（内含加密载荷） |
| Star 数 | 455+（截至 2026年7月） |

## 二、应用场景

### 2.1 商业软件分发

- 向客户分发二进制程序时，防止随意复制和逆向
- 绑定到特定机器（通过 `-l` 锁机功能），杜绝跨设备使用
- 可设置密码，只有输入正确密码才能运行

### 2.2 渗透测试与红队演练

- 绕过 AV/EDR 的静态检测：每次加密生成的签名都不同（morphing）
- 100% 内存执行，无文件落盘痕迹
- 对 ELF 二进制进行加壳，绕过基于签名的检测规则

### 2.3 Shell 脚本保护

- 保护包含敏感信息（密码、API Key、业务逻辑）的 Shell 脚本
- 防止脚本内容被 `cat`、`less` 或编辑器直接查看
- 即使脚本被复制，没有密码也无法执行

### 2.4 授权控制与试用版分发

- 使用 `-l` 将程序锁定到特定系统 UID，防止非授权使用
- 通过 `BC_LOCK` 设置自定义动作：锁定后退出、弹出警告或执行任意命令
- 结合密码机制实现试用期控制（配合外部包装脚本）

## 三、优劣分析

### 优势

| 优势 | 说明 |
|------|------|
| **零依赖** | 只需 `/bin/sh` + `perl` + `openssl`，几乎任何 Linux 系统都自带 |
| **纯内存执行** | 解密过程在内存中完成，不写临时文件，最小化取证痕迹 |
| **每次不同签名** | 随机 Padding + 随机 Salt，每次加密结果不同，防哈希签名检测 |
| **架构无关** | 输出是 Shell 脚本，能运行在任何支持上述工具的平台上 |
| **轻量小巧** | 主脚本约 30KB，加密后二进制体积通常减少 50-70% |
| **双重加密** | 支持对已加密的二进制再次加密（double/triple encrypt） |
| **锁机功能** | 绑定到特定系统和用户，跨设备自动失效 |
| **管道支持** | 可以通过管道输入输出，方便集成到自动化流水线 |

### 劣势

| 劣势 | 说明 |
|------|------|
| **非绝对安全** | 运行时密钥存在于内存中，有经验的逆向工程师可 dump 内存提取 |
| **依赖 OpenSSL** | 系统必须安装 `openssl` 命令行工具 |
| **性能开销** | 每次运行需在内存中解密，首次启动有轻微延迟（通常 <100ms） |
| **密文可见** | 加密后的文件仍是 Shell 脚本格式，内含 base64 编码的密文 payload |
| **无法保护编译语言源码** | 加密的是二进制本身而非源码，无法阻止对原始 ELF 的逆向（需配合 Obfuscator-LLVM 等） |
| **无图形界面** | 纯命令行工具，对新手有一定门槛 |

### 与其他工具对比

| 工具 | 类型 | 优点 | 缺点 |
|------|------|------|------|
| **bincrypter** | 运行时加密 | 零依赖、纯内存、架构无关 | 密钥内存中可见 |
| **UPX** | 加壳压缩 | 体积小、速度快、广泛支持 | 易脱壳、无加密 |
| **shc** | Shell 脚本加密 | 编译为二进制 | 仅支持 sh、易被提取 |
| **PyArmor** | Python 加密 | 专业混淆、绑定机器 | 仅 Python、商业版收费 |
| **Obfuscator-LLVM** | 编译时混淆 | 混淆强度高、防逆向 | 编译复杂、体积大 |

## 四、安装

`bincrypter` 是一个单文件 Shell 脚本，直接从 GitHub Releases 下载即可：

```bash
# 下载最新版
curl -SsfL https://github.com/hackerschoice/bincrypter/releases/latest/download/bincrypter -o bincrypter

# 赋予执行权限
chmod +x bincrypter

# 移动到 PATH 中（可选）
sudo mv bincrypter /usr/local/bin/
```

> 或者克隆仓库自行构建：`git clone https://github.com/hackerschoice/bincrypter.git`，然后运行 `src/make.sh` 生成 `bincrypter.sh`。

## 五、使用方法

### 5.1 基本用法 — 混淆/压缩

```bash
# 对 /usr/bin/id 进行混淆压缩
cp /usr/bin/id myid
./bincrypter myid
# 输出: Compressed: 68552 --> 24176 [35%]

# 运行加密后的程序
./myid
# uid=0(root) gid=0(root) groups=0(root)
```

### 5.2 加密 — 设置密码

```bash
# 使用密码加密
./bincrypter myprogram MySecretPassword

# 运行时需要输入密码
./myprogram
# Enter Password: ******
# (程序正常输出)
```

也可以通过环境变量传递密码（避免交互）：

```bash
PASSWORD=MySecretPassword ./bincrypter myprogram
```

### 5.3 静默模式

```bash
./bincrypter -q myprogram
# 无任何输出，静默完成加密
```

### 5.4 锁机 — 绑定到当前系统

```bash
# 锁定到当前系统 + UID
./bincrypter -l myprogram

# 将程序复制到其他机器后运行：
./myprogram
# (无输出，直接退出，不会执行原始程序)
```

自定义锁定后的行为：

```bash
# 锁定并自定义失败动作
BC_LOCK="echo '非法复制！程序已锁定'; exit 1" ./bincrypter -l myprogram
```

`BC_LOCK` 支持三种模式：
- **`BC_LOCK=0`**（默认）：静默退出，返回码 0
- **`BC_LOCK=<数字>`**：以指定数字作为退出码退出
- **`BC_LOCK=<命令>`**：执行指定的 Shell 命令（如 `echo`、`rm -rf` 等）

> BC_LOCK 也支持 base64 编码的命令字符串，方便绕过命令行审查。

### 5.5 管道模式

```bash
# 从管道读取，输出到文件
cat /usr/bin/id | ./bincrypter >id.enc
chmod +x id.enc
./id.enc

# 结合网络下载 — 实时加密
curl -SsfL "https://example.com/mybinary" | PASSWORD="foobar" ./bincrypter >mybin
chmod +x mybin
PASSWORD="foobar" ./mybin
```

### 5.6 双重加密

```bash
# 第一层加密
PASSWORD="layer1" ./bincrypter myprogram
# 第二层加密（对已加密的文件再次加密）
PASSWORD="layer2" ./bincrypter myprogram

# 运行时需要先输入 layer2，再输入 layer1
BC_PASSWORD="layer1" PASSWORD="layer2" ./myprogram
```

> 第一层使用 `BC_PASSWORD`（该变量会传递给内部解密存根），第二层使用 `PASSWORD`。

### 5.7 控制随机填充

默认情况下，bincrypter 会添加约 25% 的随机 Padding 数据以混淆原始文件大小：

```bash
# 禁用 Padding
BC_PADDING=0 ./bincrypter myprogram

# 自定义 Padding 比例（0~100）
BC_PADDING=50 ./bincrypter myprogram
```

## 六、工作原理

`bincrypter` 的工作流程可以概括为以下几个步骤：

```
原始程序 (ELF/Script)
       │
       ▼
  ① gzip 压缩
       │
       ▼
  ② 可选: 添加随机 Padding (BC_PADDING)
       │
       ▼
  ③ OpenSSL AES-256-CBC 加密
     (密钥 = Salt + Password)
       │
       ▼
  ④ base64 编码
       │
       ▼
  ⑤ 嵌入到解密存根 (Shell Stub)
       │
       ▼
  输出: 自解密的 Shell 脚本
```

运行时解密流程：

```
加密后的脚本被执行
       │
       ▼
  ① Shell 启动，执行解密存根
       │
       ▼
  ② 请求密码（交互式或从环境变量读取）
       │
       ▼
  ③ base64 解码 → OpenSSL 解密 → gzip 解压
       │
       ▼
  ④ 使用 perl 将解密后的数据加载到内存
       │
       ▼
  ⑤ 通过管道或 exec 执行原始程序
```

**关键安全特性**：
- 解密数据**从不写入磁盘**
- 使用 `perl` 的 `read()` + `print()` 在内存中传递数据
- 加密 payload 是 base64 编码的，但无密钥无法解码
- 每次加密使用随机 Salt，相同程序每次输出不同

## 七、实战案例

### 案例 1：保护自动化部署脚本

```bash
# 假设 deploy.sh 包含服务器密码等敏感信息
./bincrypter deploy.sh MyDeployPass

# 分发 deploy.sh（已加密），运行时：
# ./deploy.sh
# Enter Password: ******
# (自动执行部署)
```

### 案例 2：红队 — 绕过静态检测

```bash
# 对常见的渗透工具进行加密
cp /usr/bin/nmap mynmap
./bincrypter mynmap

# 上传到目标机器运行
./mynmap -sV target.com

# 每次加密的 md5sum 都不同，无法通过哈希匹配检测
```

### 案例 3：试用版软件授权

```bash
# 编写包装脚本 check_license.sh
cat > check_license.sh << 'EOF'
#!/bin/bash
# 简单的试用到期检查
EXPIRY="2026-12-31"
if [ "$(date +%Y%m%d)" -gt "${EXPIRY//-/}" ]; then
    echo "试用已到期"
    exit 1
fi
exec "$@"
EOF

# 加密原始程序并绑定授权检查
./bincrypter -l myapp
BC_LOCK="$(cat check_license.sh | base64 -w0)" ./bincrypter -l myapp
```

### 案例 4：CI/CD 流水线集成

```bash
# GitHub Actions / GitLab CI 中加密构建产物
- name: Encrypt binary
  run: |
    curl -sSfL https://github.com/hackerschoice/bincrypter/releases/latest/download/bincrypter -o bincrypter
    chmod +x bincrypter
    PASSWORD="${{ secrets.APP_PASSWORD }}" ./bincrypter myapp
```

## 八、安全注意事项

1. **没有绝对的安全**：bincrypter 提供的是**混淆 + 加密**保护，而非理论上的不可破解。任何在内存中解密的程序都可以被 dump。

2. **密钥管理**：
   - 密码嵌入脚本或环境变量中运行时，可以在 `/proc/<pid>/environ` 中读取
   - 建议配合外部密钥管理服务（如 Vault）使用

3. **反调试对抗**：
   - bincrypter 自身不提供反调试功能
   - 如需更高安全性，可先用 Obfuscator-LLVM 混淆原始 ELF，再用 bincrypter 加密

4. **误报风险**：
   - 加密后的脚本可能被杀毒软件标记为可疑（自解密 + 加密载荷特征）
   - 建议在目标杀软环境中测试

5. **合规要求**：
   - 某些国家/地区对加密软件有出口管制
   - 商业分发请咨询法律顾问

## 九、总结

`bincrypter` 是一个**轻量、实用、零依赖**的二进制/脚本加密工具，特别适合以下场景：

| 场景 | 推荐程度 |
|------|---------|
| Shell 脚本含敏感信息 | ⭐⭐⭐⭐⭐ |
| 红队 / 渗透测试 | ⭐⭐⭐⭐⭐ |
| 商业软件快速加壳 | ⭐⭐⭐⭐ |
| 试用版授权绑定 | ⭐⭐⭐⭐ |
| 高安全性商业分发 | ⭐⭐⭐（需配合其他工具） |
| 防止反编译 | ⭐⭐（不阻挡 ELF 逆向） |

它的核心理念是 **"足够好"的安全** — 增加破解成本，使其不值得被攻击。如果你的需求是防止"顺手 cat 查看脚本"或"快速复制到其他机器运行"级别的保护，bincrypter 是绝佳选择。但对于国家级 APT 级别的攻击者，需要配合更专业的保护方案（如白盒加密、TEE 可信执行环境等）。

---

*项目主页：[https://github.com/hackerschoice/bincrypter](https://github.com/hackerschoice/bincrypter)*
*作者网站：[https://thc.org](https://thc.org)*
