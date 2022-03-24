---
title: DD-WRT 通过SSH使用WOL
categories:
  - dd-wrt
  - 路由器
date: 2020-01-06 16:13:03
tags:
  - dd-wrt
  - 路由器
---



<a name="vQurC"></a>
### WOL through Telnet/SSH
**Note:** This is the preferred method to send WOL magic packets remotely.

If you have local or remote Telnet/SSH access to your router, you can wake up a machine on the LAN by using the following command:

```
/usr/sbin/wol -i 192.168.1.255 -p PP AA:BB:CC:DD:EE:FF
```

Note that the full path to "/usr/sbin/wol" is important. Simply "wol" will not work.

Substitute _AA:BB:CC:DD:EE:FF_ with the actual MAC address of the computer which you wish to boot remotely. Likewise, replace _192.168.1.255_ with the actual broadcast address of the network (192.168.1.255 is the broadcast address when the machine has an IP of 192.168.1.x and subnet mask of 255.255.255.0). Replace "PP" with the port number your machine listens on (usually 7 or 9).


```
/usr/sbin/wol -i 192.168.1.255 -p 9 24:5E:BE:32:C8:EB
```
