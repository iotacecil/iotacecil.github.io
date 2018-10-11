@echo off
set /p name=input pages name:
echo name:%name%
echo please wait
hexo new %name% && call 3.bat %name%
pause