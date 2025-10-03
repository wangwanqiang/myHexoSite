---
title: ssh 通过证书建立信任关系（转）（备用）
id: 264
categories:
  - 未分类
abbrlink: 26b1
date: 2017-10-17 14:35:06
tags:
---
# 建立SSH信任
将A主机做为客户端（发起SSH请求 ip:192.168.200.170）
将B主机作为服务器端（接收ssh请求   ip:192.168.200.149）
以上以主动发起SSH登录请求的主机和接收请求的主机进行分类
## A主机生成公，私钥证书

~~~
[root@buddytj-10 .ssh]# ssh-keygen -t rsa     #rsa算法的证书
Generating public/private rsa key pair. （以下一路回车）
Enter file in which to save the key (/root/.ssh/id_rsa):

/root/.ssh/id_rsa already exists.
Overwrite (y/n)? y                      （因为我的证书已存在，覆盖即可）
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa. （私钥）
Your public key has been saved in /root/.ssh/id_rsa.pub. （公钥）
The key fingerprint is:
c1:26:cc:88:2b:05:dd:c3:6b:1e:78:5d:da:9c:da:8a 
证书就生成了   id_rsa （私钥）|&amp; id_rsa.pub （公钥） 
~~~

## 将A主机生成的公钥传递给B主机 
~~~
[root@xyh .ssh]#scp id_rsa.pub  192.168.200.149：/root/.ssh/
在B主机上将A的公钥更名为
[root@xyh .ssh]#mv id_rsa.pub authorized_keys 
~~~
至此从A主机远程SSH B主机的工作即告完成