Windows 远程 SSH 连接 WSL 完整步骤

一、WSL 端配置（先在本机 WSL 里操作）

1. 安装 openssh-server
sudo apt update
sudo apt install openssh-server -y
2. 修改 SSH 配置，允许密码登录
sudo vim /etc/ssh/sshd_config
找到并修改这几项：
PasswordAuthentication yes
PermitRootLogin no
PubkeyAuthentication yes
保存退出：Esc → 输入 :wq 回车

3. 设置 WSL 用户密码（没密码必须设）
passwd
4. 重启 SSH 服务
sudo service ssh restart
# 设置开机自启
sudo systemctl enable ssh
5. 查看 WSL IP
ip addr
一般看到 eth0 里的 172.x.x.x 地址，记下来

二、本机 Windows 测试连接

打开 PowerShell/CMD
ssh 你的WSL用户名@WSL的IP
输入WSL密码即可登录

三、局域网其他电脑远程连 WSL

1. Windows 放行 WSL SSH 端口

WSL 默认端口 22

1. 打开Windows Defender 防火墙

2. 新建入站规则：允许 22 端口 TCP

3. 专用/公用网络都勾选

2. 查看宿主机 Windows 局域网 IP
ipconfig
记下以太网/WiFi IPv4（192.168.x.x）

3. WSL 设置端口转发（关键）

把宿主机22端口流量转发到WSL内部22
管理员 PowerShell 执行：
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=22 connectaddress=WSL的IP connectport=22
查看转发规则：
netsh interface portproxy show all
四、其他设备远程连接

任意电脑、手机、另一台Windows/Mac
ssh WSL用户名@宿主机Windows局域网IP -p 22
五、常用问题排查

1. 连不上：检查ssh服务、防火墙、端口转发

2. 密码拒绝：确认PasswordAuthentication yes

3. 重启WSL后IP变了：重新执行端口转发即可

4. 关闭端口转发：
netsh interface portproxy delete v4tov4 listenport=22 listenaddress=0.0.0.0
六、可选：固定WSL IP

避免每次重启IP变动，可设置WSL静态IP，需要我给你一键固定脚本吗？