@echo off
chcp 65001

%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c ""%~s0"" ::","","runas",1)(window.close)&&exit

echo 启动代理,请确保 80 端口没有被占用
echo.

if exist backup\hosts.bak goto backup_exists
echo 正在创建备份
copy /y "C:\Windows\System32\drivers\etc\hosts" "backup\hosts.bak"
echo 备份完成
echo.
goto write_start

:backup_exists
echo 备份已存在,无需备份。
echo.

:write_start
echo 正在添加 host 记录,请确保杀毒软件均已放行
echo 127.0.0.1 gms.yoyogames.com >> C:\Windows\System32\drivers\etc\hosts
echo 添加完成
echo.

if exist "C:\Windows\System32\curl.exe" goto download_rss
else if exist ".\curl.exe" goto download_rss_manually_curl
else goto download_curl_notfound

if exist "htdocs\Zeus-Runtime.rss" del /q "htdocs\Zeus-Runtime.rss"
if exist "htdocs\Zeus-Runtime-NuBeta.rss" del /q "htdocs\Zeus-Runtime-NuBeta.rss"

:download_rss
echo 下载镜像站 RSS,将调用系统内置 curl(适用于2022-01更新后的 Windows 10 和 Windows 11)。
cd htdocs
curl -O https://gms.magecorn.com/Zeus-Runtime.rss
cd ..
goto run_httpd

:download_rss_manually_curl
echo 下载镜像站 RSS,调用手动下载的 curl。
cd htdocs
.\curl.exe -O https://gms.magecorn.com/Zeus-Runtime.rss
cd ..
goto run_httpd

:download_curl_notfound
echo 内置 curl 不存在,请从 https://curl.se/windows/ 手动下载并提取 curl.exe 到本目录下。
echo 并重启本脚本
pause

:run_httpd
echo 启动 TinyHTTPd,如需关闭可按下 Ctrl + C,若 TinyHTTPd 提示 startup bind: No error 并退出请检查 80 端口是否被占用：
tinyhttp
