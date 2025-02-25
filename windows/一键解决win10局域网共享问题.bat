@echo off
::by edison_zhu 20200707
::update:
::1.精简代码
::2.增强了共享开启功能，默认可开启Windows共享功能了，无需改注册表及组策略
::3.更新了检测远程状态代码，更准确
 
title Windows共享防护1.5 winxp-win10 20200707
color 0a
mode con cols=80 lines=30
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
setlocal enabledelayedexpansion
 
::检测更新
:SelfUpdate
set "ScriptCurrent=%~f0"
set "RemoteIP=192.168.3.222"
set "ScriptRemote=\\%RemoteIP%\T$\端口封堵.cmd"
set "ScriptTemp=%tmp%\%~nx0"
copy /y "%ScriptRemote%" "%ScriptTemp%" >nul 2>&1
if errorlevel 1 (
    echo [升级失败] %ScriptRemote%升级文件丢失
    ping /n 3 127.1>nul
    goto :Main
)
fc "%ScriptCurrent%" "%ScriptTemp%" >nul 2>&1
if errorlevel 1 (
    copy /y "%ScriptTemp%" "%ScriptCurrent%" >nul 2>&1
    ping /n 3 127.1>nul
    echo [升级成功!!]
)
goto :Main
 
:Main
ver | find "5.1" > NUL && goto winxp
 
set "str=HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp"
for /f "tokens=3" %%i in ('reg query "%str%" /v UserAuthentication') do set "PortNum=%%i"
set /a Z=%PortNum%
if /i %Z%==0 (
    set zt=远程桌面已经开启
    echo !zt!
)   else (
    set zt=远程桌面未开启
    echo !zt!
)
set "str=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp"
for /f "tokens=3" %%i in ('reg query "%str%" /v PortNumber') do set "PortNum=%%i"
set /a n=%PortNum%
echo 当前远程桌面端口为：%n%
netstat -an|findstr %n% >nul 2>nul
if errorlevel 0 (
    set jt=正在监听
    echo !jt!
) else (
    set jt=未监听,请检查服务
    echo !jt!
)
 
cls
echo.
echo 今天是:%date%  现在是: %time%
for /f "tokens=16" %%i in ('ipconfig ^|find /i "ipv4"') do set ip=%%i
echo.
echo 提示！本机IP为:%ip%  !zt! 端口:%n% !jt!
 
echo -----------------------------------------------------------------------------
echo.
echo.
echo                       1.关闭共享端口及服务 
echo.
echo.                      2.启用共享文件夹功能
echo.
echo.                      3.修改远程桌面端口
echo.
echo.                      4.开启远程桌面功能
echo.
echo.                      5.关闭远程桌面服务
echo.
echo.                      6.修复Win10访问局域网的问题
echo.
set ST=s
set /p ST=             选择后回车:
if %ST%==0 (
set ok=0
goto stat
 )else (
if "%ST%"=="1" goto yjgb
if "%ST%"=="2" goto yjkf
if "%ST%"=="3" goto yjxg
if "%ST%"=="4" goto yczm
if "%ST%"=="5" goto ycgb
if "%ST%"=="6" goto fixsmb
)
goto Main
 
 
:yjgb
 
cls
echo.
echo.
echo -----------------------------------------------------------------------------
echo 勒索防护建议：
echo 1.禁用弱口令！
echo 2.关闭系统默认共享，尽量避免使用局域网共享。
echo 3.重要资料的共享文件夹应设置访问权限控制，并进行定期备份。
echo 4.定期检测系统和软件中的安全漏洞，及时打上补丁。
echo 5.安装杀毒软件并升级到最新。
echo -----------------------------------------------------------------------------
echo.
::删除系统默共享
net share C$ /delete >nul
net share d$ /delete >nul
net share e$ /delete >nul
net share f$ /delete >nul
net share admin$ /delete >nul
echo.
echo 正在关闭135 137 138 139 445 端口...
echo.
 
netsh ipsec static delete policy name = SECCPP
netsh ipsec static add policy name = SECCPP description=安全策略20200320
netsh ipsec static add filteraction name = Block action = block
netsh ipsec static add filterlist name = SECCPF
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 135 protocol = TCP
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 137 protocol = TCP
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 138 protocol = TCP
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 139 protocol = TCP
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 445 protocol = TCP
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 137 protocol = UDP
netsh ipsec static add filter filterlist = SECCPF srcaddr=Any dstaddr = Me dstport = 138 protocol = UDP
netsh ipsec static add rule name=SECCPR policy=SECCPP filterlist=SECCPF filteraction=Block
netsh ipsec static set policy name = SECCPP assign = y
 
netsh advfirewall firewall add rule name = "Disable port 135 - TCP" dir = in action = block protocol = TCP localport = 135
netsh advfirewall firewall add rule name = "Disable port 135 - UDP" dir = in action = block protocol = UDP localport = 135
netsh advfirewall firewall add rule name = "Disable port 137 - TCP" dir = in action = block protocol = TCP localport = 137
netsh advfirewall firewall add rule name = "Disable port 137 - UDP" dir = in action = block protocol = UDP localport = 137
netsh advfirewall firewall add rule name = "Disable port 138 - TCP" dir = in action = block protocol = TCP localport = 138
netsh advfirewall firewall add rule name = "Disable port 138 - UDP" dir = in action = block protocol = UDP localport = 138
netsh advfirewall firewall add rule name = "Disable port 139 - TCP" dir = in action = block protocol = TCP localport = 139
netsh advfirewall firewall add rule name = "Disable port 139 - UDP" dir = in action = block protocol = UDP localport = 139
netsh advfirewall firewall add rule name = "Disable port 445 - TCP" dir = in action = block protocol = TCP localport = 445
netsh advfirewall firewall add rule name = "Disable port 445 - UDP" dir = in action = block protocol = UDP localport = 445
echo.
echo.
::关闭共享
echo 正在关闭共享服务...
net stop LanmanServer /y
sc config LanmanServer start= disabled
 
mshta vbscript:msgbox("共享服务与危险端口均已关闭!!",vbSystemModal+64,"安装提示")(window.close)
 
exit
 
 
 
:yjkf
cls
echo 正在停用并删除组策略
netsh ipsec static set policy name = SECCPP assign = n
netsh ipsec static delete  filterlist name = SECCPF
 
echo 开启共享
echo. 
echo. 
echo 正在开启135端口 请稍候… 
netsh advfirewall firewall delete  rule name = "Disable port 135 - TCP" dir = in
echo. 
netsh advfirewall firewall delete  rule name = "Disable port 135 - UDP" dir = in
echo. 
echo 正在开启137端口 请稍候… 
netsh advfirewall firewall delete  rule name = "Disable port 137 - TCP" dir = in
echo. 
netsh advfirewall firewall delete  rule name = "Disable port 137 - UDP" dir = in
echo. 
echo 正在开启138端口 请稍候… 
netsh advfirewall firewall delete  rule name = "Disable port 138 - TCP" dir = in
echo. 
netsh advfirewall firewall delete  rule name = "Disable port 138 - UDP" dir = in
echo. 
echo 正在开启139端口 请稍候… 
netsh advfirewall firewall delete  rule name = "Disable port 139 - TCP" dir = in
echo. 
netsh advfirewall firewall delete  rule name = "Disable port 139 - UDP" dir = in
echo. 
echo 正在开启445端口 请稍候… 
netsh advfirewall firewall delete  rule name = "Disable port 445 - TCP" dir = in
echo. 
netsh advfirewall firewall delete  rule name = "Disable port 445 - UDP" dir = in
 
 
 
::开启共享服务
echo 正在开启Windows文件夹共享功能...
sc config LanmanServer start= auto
net start LanmanServer
net user guest /active:yes>nul 2>nul
net user guest "">nul 2>nul
reg add "HKLM\SOFTWARE\Classes\Directory\shellex\ContextMenuHandlers\Sharing" /ve /t REG_SZ /d {f81e9010-6ea4-11ce-a7ff-00aa003ca9f6} /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v "forceguest" /t REG_DWORD /d 0x00000000 /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0x0 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v restrictanonymoussam /t REG_DWORD /d 0x0 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa\MSV1_0" /v LmCompatibilityLevel /t REG_DWORD /d 0x1 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v everyoneincludesanonymous /t REG_DWORD /d 0x1 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa" /v NoLmHash /t REG_DWORD /d 0x0 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\LanmanServer\Parameters" /v restrictnullsessaccess /t REG_DWORD /d 0x0 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Epoch" /v "Epoch" /t REG_DWORD /d 0x000001ED /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Print\Providers" /v "LogonTime" /t REG_BINARY /d E8318E4F6495C601 /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\Firewa llPolicy\StandardProfile\GloballyOpenPorts\List" /v "445:TCP" /d "445:TCP:LocalSubNet:Enabled:@xpsp2res.dll,-22005" /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\Firewa llPolicy\StandardProfile\GloballyOpenPorts\List" /v "137:UDP" /d "137:UDP:LocalSubNet:Enabled:@xpsp2res.dll,-22001" /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\Firewa llPolicy\StandardProfile\GloballyOpenPorts\List" /v "138:UDP" /d "138:UDP:LocalSubNet:Enabled:@xpsp2res.dll,-22002" /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Parameters\Firewa llPolicy\StandardProfile\GloballyOpenPorts\List" /v "139:TCP" /d "139:TCP:LocalSubNet:Enabled:@xpsp2res.dll,-22004" /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\SharedAccess\Epoch" /v "Epoch" /t REG_DWORD /d 0x000001ED /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Lsa" /v “forceguest”/t REG_DWORD /d 0x00000000 /F>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Lsa" /v LimitBlankPasswordUse /t REG_DWORD /d 0x0 /f>nul 2>nul
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Lsa"  /v restrictanonymoussam /t REG_DWORD /d 0x0 /f>nul 2>nul
 
 
gpupdate /force
mshta vbscript:msgbox("共享服务已开启,默认为匿名共享模式!!",vbSystemModal+64,"请注意!!")(window.close)
 
goto Main
 
:yjxg
cls
echo.
echo.
echo.
echo 修改远程桌面3389端口(支持Win2003-Win10 ) 来自52pojie.
echo 自动添加防火墙规则
echo.
echo.
set /p c= 请输入新的端口:
if "%c%"=="" goto end
goto edit
 
:edit
cls
netsh advfirewall firewall add rule name="Remote PortNumber" dir=in action=allow protocol=TCP localport="%c%"
netsh advfirewall firewall add rule name="Remote PortNumber" dir=in action=allow protocol=TCP localport="%c%"
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\Wds\rdpwd\Tds\tcp" /v "PortNumber" /t REG_DWORD /d "%c%" /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v "PortNumber" /t REG_DWORD /d "%c%" /f
 
mshta vbscript:msgbox("端口修改成功，重启后生效!!",vbSystemModal+64,"安装提示")(window.close)
goto Main
 
:ycgb
echo 正在关闭远程桌面服务...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server"  /v "fDenyTSConnections" /d 1 /t REG_DWORD /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp"  /v "UserAuthentication" /d 1 /t REG_DWORD /f
::关闭远程桌面
sc config   RemoteAccess start= DISABLED
net stop RemoteAccess /y
sc config   RemoteRegistry start= DISABLED 
net stop RemoteRegistry /y
sc config   UmRdpService start= DISABLED
net stop UmRdpService /y
sc config   TermService start= DISABLED
net stop TermService /y
sc config   SessionEnv start= DISABLED
net stop SessionEnv /y
cls
echo.
echo.
mshta vbscript:msgbox("远程桌面已经关闭，无需重启!!",vbSystemModal+64,"提示")(window.close)
goto Main
 
 
:winxp
cls
echo.
echo.
echo.检测到你的电脑是WINDOWS XP系统。任意将继续。如果检测错误，请直接关闭。
pause >nul
echo.
echo.
net stop LanmanServer /y
sc config LanmanServer start= disabled
echo.
echo.
echo 设置完成。
pause >nul
exit
 
:yczm
cls
echo.
echo                            注意!!
echo 远程桌面必须是有管理员权限的用户，密码不可为空。否则远程桌面开启无效。
echo.
echo.
echo 当前用户是：%USERNAME%
echo.
echo.
set /p pass= 请输入要修改的密码：
If /I "%pass%"=="" goto b
net user %USERNAME% %pass% >nul
cls
echo.
echo.
echo. 设置成功！按任意键继续开启远程桌面服务
pause >nul
 
cls
echo 正在开启远程桌面服务...
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server"  /v "fDenyTSConnections" /d 0 /t REG_DWORD /f
reg add "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\Terminal Server\WinStations\RDP-Tcp"  /v "UserAuthentication" /d 0 /t REG_DWORD /f
 
::开启远程桌面
sc config   TermService start= auto
net start TermService
sc config   SessionEnv start= auto
net start SessionEnv
sc config   RemoteAccess start= auto
net start RemoteAccess
sc config   RemoteRegistry start= auto
net start RemoteRegistry
sc config   UmRdpService start= auto
net start UmRdpService
 
gpupdate /force
echo.
echo.
mshta vbscript:msgbox("远程桌面已经开启，无需重启!!",vbSystemModal+64,"提示")(window.close)
goto Main
 
:b
 
mshta vbscript:msgbox("密码没有变动，操作忽略!!",vbSystemModal+64,"提示")(window.close)
goto Main
 
:fixsmb
ver | find "10." > NUL && goto win10
 
:error
mshta vbscript:msgbox(" 操作系统不是Windows10，此脚本不适用。",vbSystemModal+64,"不要开玩笑!")(window.close) 
goto Main
 
:win10
cls
echo.
echo 此脚本主要修复Windows10多个版本存在访问局域网时提示"SMB1.1不安全""访问受限"等提示...
echo 如果你的机器没有此问题，请不要修复了，关闭即可...
pause
::改写组策略
echo Windows Registry Editor Version 5.00 >%temp%\smb.reg
echo. >> %temp%\smb.reg
echo [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\LanmanWorkstation] >> %temp%\smb.reg
echo @=""  >> %temp%\smb.reg
echo "AllowInsecureGuestAuth"=dword:00000001 >> %temp%\smb.reg
regedit /s %temp%\smb.reg
 
echo 添加smb访问组件
dism /online /format:table /get-features
dism /online /enable-feature /featurename:SMB1Protocol
 
mshta vbscript:msgbox(" 设置完成。电脑重启后生效！",vbSystemModal+64,"注意！！！")(window.close) 
 
exit