@echo off

echo Checking if i should run in Normal Mode or special Mode
echo Please connect your device with USB-Debugging enabled now
echo Waiting for device to show up, if nothing happens please check if Windows ADB-drivers are installed correctly!
adb wait-for-device
adb pull /system/app/Backup-Restore.apk . > NUL
adb pull /system/bin/ric . > NUL
if EXIST ric (set ric=1) else (echo .)
if EXIST Backup-Restore.apk (GOTO XPS) else (echo .)
echo Above file not found warning ARE NOT ERRORS, it is intended to be this way!
GOTO OTHER

:XPS
echo.
echo Found Sony Backup-Restore.apk
echo LT26,LT22 etc. mode enabled!
echo.
del Backup-Restore.apk
if %ric% == 1 (del ric) else (echo .)
set NXT=1
GOTO START

:START
adb wait-for-device
IF %type% == 2 GOTO TABTRICK
echo Pushing busybox....
adb push /busybox /data/local/tmp/busybox
echo Pushing su binary ....
adb push /su /data/local/tmp/su
echo Pushing Superuser app
adb push /Superuser.apk /data/local/tmp/.
echo Making busybox runable ...
adb shell chmod 755 /data/local/tmp/busybox
if %ric% == 1 (adb push /ric /data/local/tmp/ric) else (echo .)
IF %nxt% == 1 GOTO XPSTRICK
adb restore /fakebackup.ab
echo Please look at your device and click RESTORE!
echo If all is successful i will tell you, if not this shell will run forever.
echo Running ...
adb shell "while ! ln -s /data/local.prop /data/data/com.android.settings/a/file99; do :; done" > NUL
echo Successful, going to reboot your device in 10 seconds!
ping -n 10 127.0.0.1 > NUL
adb reboot
echo Waiting for device to show up again....
ping -n 10 127.0.0.1 > NUL
adb wait-for-device
GOTO NORMAL

:NORMAL
IF %ric% == 1 GOTO RICSTUFF
echo Going to copy files to it's place
adb shell "/data/local/tmp/busybox mount -o remount,rw /system && /data/local/tmp/busybox mv /data/local/tmp/su /system/xbin/su && /data/local/tmp/busybox mv /data/local/tmp/Superuser.apk /system/app/Superuser.apk && /data/local/tmp/busybox cp /data/local/tmp/busybox /system/xbin/busybox && chown 0.0 /system/xbin/su && chmod 06755 /system/xbin/su && chmod 655 /system/app/Superuser.apk && chmod 755 /system/xbin/busybox && rm /data/local.prop && reboot"
IF %foo% == 1 GOTO REENTER

:RICSTUFF
echo Going to copy files to it's place
adb shell "/data/local/tmp/busybox mount -o remount,rw /system && /data/local/tmp/busybox mv /data/local/tmp/ric /system/bin/ric && chmod 755 /system/bin/ric && /data/local/tmp/busybox mv /data/local/tmp/su /system/xbin/su && /data/local/tmp/busybox mv /data/local/tmp/Superuser.apk /system/app/Superuser.apk && /data/local/tmp/busybox cp /data/local/tmp/busybox /system/xbin/busybox && chown 0.0 /system/xbin/su && chmod 06755 /system/xbin/su && chmod 655 /system/app/Superuser.apk && chmod 755 /system/xbin/busybox && rm /data/local.prop && reboot"
IF %foo% == 1 GOTO REENTER
GOTO FINISH

:REENTER
echo Rebooting again, please wait!
del ric
ping -n 3 127.0.0.1 > NUL
adb wait-for-device
echo Restoring previous Backup! Please select the RESTORE MY DATA option now on your device!
adb restore mysettings.ab
echo Please press any Key when restore is done.
pause
echo Going to reboot last time now ...
adb reboot
del mysettings.ab
GOTO FINISH

:OTHER
echo.
echo Normal Mode enabled!
if %ric% == 1 (del ric) else (echo .)
echo.

:FINISH
echo This root was created by B1n4ry
echo Credit goes to him, I just put it in the tool.
echo Billy
pause