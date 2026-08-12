@echo off
setlocal

if not exist "%~dp0build" mkdir "%~dp0build"
if defined DOLETC (
  set "COMPILER=%DOLETC%"
) else (
  set "COMPILER=doletc"
)

"%COMPILER%" "%~dp0main.dlt" -o "%~dp0build\dopm.exe" -O3 --target windows/x86_64
exit /b %errorlevel%
