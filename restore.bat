@echo off
chcp 65001

%1 start "" mshta vbscript:CreateObject("Shell.Application").ShellExecute("cmd.exe","/c ""%~s0"" ::","","runas",1)(window.close)&&exit

echo 正在还原备份,请确保杀毒软件均已放行
copy /y "backup\hosts.bak" "C:\Windows\System32\drivers\etc\hosts"
echo 还原完成
pause