@echo off

rem ##########################################################################
rem # Copyright 2009-2011, LAMP/EPFL
rem #
rem # This is free software; see the distribution for copying conditions.
rem # There is NO warranty; not even for MERCHANTABILITY or FITNESS FOR A
rem # PARTICULAR PURPOSE.
rem ##########################################################################

if "%OS%"=="Windows_NT" @setlocal

if "%ANDROID_SDK_HOME%"=="" (
  set ANDROID_SDK_HOME=%USERPROFILE%
)

if not "%ANDROID_SDK_ROOT%"=="" goto emulator

rem :guess1
call :set_8dot3 _GUESS "%SystemDrive%\android-sdk-windows\"
if not exist %_GUESS%tools\emulator.exe goto guess2
set ANDROID_SDK_ROOT=%_GUESS%
goto emulator

:guess2
call :set_8dot3 _GUESS "%ProgramFiles%\android-sdk-windows\"
if not exist %_GUESS%tools\emulator.exe goto guess3
set ANDROID_SDK_ROOT=%_GUESS%
goto emulator

:guess3
call :set_8dot3 _GUESS "%ProgramFiles(x86)%\Android\android-sdk\"
if not exist %_GUESS%tools\emulator.exe goto error1
set ANDROID_SDK_ROOT=%_GUESS%

:emulator
set _EMULATOR=%ANDROID_SDK_ROOT%\tools\emulator.exe
if not exist "%_EMULATOR%" goto error2

if "%ANDROID_AVD%"=="" (
  set _AVD=API_9
) else (
  set _AVD=%ANDROID_AVD%
)

if not exist "%ANDROID_SDK_HOME%\androi~1\avd\%_AVD%.ini" goto error3
set _AVD_HOME=%ANDROID_SDK_HOME%\androi~1\avd

if "%ANDROID_EMULATOR_OPTS%"=="" (
  set _EMULATOR_OPTS=-no-boot-anim -no-skin
  if exist "%_AVD_HOME%\%_AVD%.avd-custom\ramdisk.img%" (
    set _RAMDISK=%_AVD_HOME%\%_AVD%.avd-custom\ramdisk.img
  )
)
if not "%_RAMDISK%"=="" (
  set _EMULATOR_OPTS=%_EMULATOR_OPTS% -ramdisk "%_RAMDISK%"
)

rem echo "%_EMULATOR%" %_EMULATOR_OPTS% -avd %_AVD%
"%_EMULATOR%" %_EMULATOR_OPTS% -avd %_AVD%
goto end

:set_8dot3
  set %~1=%~dps2
goto :eof

rem ##########################################################################
rem # errors

:error1
echo Error: environment variable ANDROID_SDK_ROOT is undefined. It should point to your installation directory.
goto end

:error2
echo Error: Emulator '%_EMULATOR%' is unknown.
goto end

:error3
echo Error: Device '%_AVD%' is unknown.
echo   We cannot execute %_EMULATOR%
goto end

:end
if "%OS%"=="Windows_NT" @endlocal
