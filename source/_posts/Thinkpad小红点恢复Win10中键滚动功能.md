title: Thinkpad 小红点恢复Win10中键滚动功能
author: Wanqiang


<a name="CQHzT"></a>
## 问题
在Windows 10下面，按住中键，拔动小红点，页面滚动的同时，光标也会一起跑。控制面板中也找不到设置的地方。

<a name="F5UoG"></a>
## 解决方案

需要修改注册表：<br />在HKEY_CURRENT_USER\Software\Synaptics\SynTPEnh\UltraNavPS2中，把TrackPointModeFunction的值修改一下即可。<br />原为："TrackPointModeFunction"=dword:00000011<br />改为："TrackPointModeFunction"=dword:00000010<br />这样就跟以前使用完全相同了，中键点击是小手或指针，滚动是鼠标中键滚动的图标，一切完美。
