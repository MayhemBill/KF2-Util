@echo off &TITLE Kindle Fire 2nd Gen Utility

:home
cls
echo What do you want to do?
echo.
echo =======================
echo.
echo 1) Verify Kindle 2
echo 2) Root Kindle (B1n4ry Method)
echo 3) Install Old Bootloader and TWRP
echo 4) Install ROM (untested)
echo 5) Xposed Installer (requires root)
echo 6) Install Drivers (DO THIS FIRST)
echo 7) Bootloop fix (Testing)
echo 8) Exit
echo.
set /p web=Type option:
if "%web%"=="1" goto verify
if "%web%"=="2" goto root
if "%web%"=="3" goto oldbltwrp
if "%web%"=="4" goto rom
if "%web%"=="5" goto xposed
if "%web%"=="6" goto drivers
if "%web%"=="7" goto blfix
if "%web%"=="8" goto exit
goto home


:verify
cls
echo This should return "product: otter2-XXX-XX"
fastboot -i 0x1949 getvar product
echo If it doesn't match, DO NOT CONTINUE, YOU WILL RECEIVE A BRICK
pause
goto home

:root
start %~dp0\Resources\root.bat
goto home

:oldbltwrp
cls
echo flashing old bootloader
fastboot -i 0x1949 flash bootloader %~dp0\Resources\Bootloader\otter2-u-boot-prod-10.2.4.bin
echo When that has finished, hit enter
pause
echo flashing TWRP recovery
fastboot -i 0x1949 flash recovery %~dp0\Resources\Bootloader\otter2-twrp-2.6.3.1-recovery.img
echo When that has finished, hit enter
pause
echo Flashing Freedom Boot
fastboot -i 0x1949 flash boot %~dp0\Resources\Bootloader\otter2-freedom-boot-10.4.6.img
echo move from your fastboot cable to your data cable then hit enter
pause
fastboot -i 0x1949 oem recovery
goto home

:rom
echo MAKE SURE YOU HAVE PUT YOUR ROM.ZIP IN THE ROMS FOLDER BEFORE CONTINUING
echo MAKE SURE YOU HAVE A NORMAL DATA CABLE CONNECTED BEFORE CONTINUING
pause
adb reboot recovery
echo go to Advanced -> adb sideload and enable it, make sure to check wipe dalvik and cache
echo press enter when you have done this
pause
adb sideload %~dp0\ROMS\rom.zip
pause
goto home

:xposed
cls
echo "Make sure ADB is installed, and "allow installation of apps from unknown sources" is checked"
echo "THIS IS A ROOT APPLICATION, MAKE SURE YOU ROOT BEFORE INSTALLING"
pause
adb install %~dp0\Resources\xposed.apk
pause
goto home

:drivers
start %~dp0\Resources\drivers\KindleDrivers.exe /S
pause
goto home

:blfix
echo connect Kindle via Fastboot cable
fastboot –i 0x1949 –w
echo insert regular data cable now
pause
fastboot –i 0x1949 reboot
goto home

:exit
exit