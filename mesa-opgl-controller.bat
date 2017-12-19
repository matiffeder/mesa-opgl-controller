@echo off
mode con cols=50 lines=23
title Mesa OpenGL Controller
:menu
cls
set choice=
@ ECHO.
@ ECHO.  Number = Mesa OpenGL Version, eg. 3.3
@ ECHO.  D = Delete Mesa OpenGL Setting
@ ECHO.
set /p choice=Enter OpenGL version or D, then press [Enter]:
echo %choice%|findstr "^[1-9][\.][0-9]$" >nul
if %errorlevel%==0 goto setting
if /i "%choice%"=="D" goto deleting
@ ECHO.
ECHO Invalid
ping -n 2 127.1 >nul
goto menu

:setting
@ ECHO.
ECHO Setted OpenGL Version: %choice%
ping -n 2 127.1 >nul
reg add HKEY_CURRENT_USER\Environment /v MESA_GL_VERSION_OVERRIDE /t REG_EXPAND_SZ /d "%choice%" /f >nul
goto setting2

:setting2
cls
set glsl=
@ ECHO.
@ ECHO.If need, please enter OpenGLSL version, eg. 330
set /p glsl=If you do not need, just press [Enter]:
if [%glsl%]==[] (
	reg delete HKEY_CURRENT_USER\Environment /v MESA_GLSL_VERSION_OVERRIDE /f >nul 2>&1
	goto finish)
echo %glsl%|findstr "^[1-9][0-9][0]$" >nul
if %errorlevel%==1 (
	ECHO Invalid
	ping -n 2 127.1 >nul
	goto setting2)
@ ECHO.
ECHO Setted OpenGLSL Version: %glsl%
reg add HKEY_CURRENT_USER\Environment /v MESA_GLSL_VERSION_OVERRIDE /t REG_EXPAND_SZ /d "%glsl%" /f >nul
goto finish

:deleting
@ ECHO.
reg delete HKEY_CURRENT_USER\Environment /v MESA_GL_VERSION_OVERRIDE /f >nul
reg delete HKEY_CURRENT_USER\Environment /v MESA_GLSL_VERSION_OVERRIDE /f >nul 2>&1
ECHO Deleted Mesa OpenGL, GLSL Setting
goto finish

:finish
ping -n 2 127.1 >nul
taskkill /f /im explorer.exe >nul
explorer.exe >nul
exit
REM matif