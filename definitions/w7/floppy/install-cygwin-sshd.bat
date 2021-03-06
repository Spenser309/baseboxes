REM http://webcache.googleusercontent.com/search?q=cache:SjoPPpuQxuoJ:www.tcm.phy.cam.ac.uk/~mr349/cygwin_install.html+install+cygwin+ssh+commandline&cd=2&hl=nl&ct=clnk&gl=be&source=www.google.be

REM create the cygwin directory
cmd /c mkdir %SystemDrive%\cygwin

cmd /c bitsadmin /transfer CygwinSetupExe /download /priority normal http://www.cygwin.com/setup-x86_64.exe %SystemDrive%\cygwin\cygwin-setup.exe

REM goto a temp directory
cd %SystemDrive%\windows\temp

REM run the installation
cmd /c %SystemDrive%\cygwin\cygwin-setup.exe -q -R %SystemDrive%\cygwin -P openssh,openssl,curl,cygrunsrv,wget,rebase,vim -s http://cygwin.mirrors.pair.com

%SystemDrive%\cygwin\bin\bash -c 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin cygrunsrv -R sshd'

REM /bin/ash is the right shell for this command
cmd /c %SystemDrive%\cygwin\bin\ash -c /bin/rebaseall

cmd /c %SystemDrive%\cygwin\bin\bash -c 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin mkgroup -l'>%SystemDrive%\cygwin\etc\group

cmd /c %SystemDrive%\cygwin\bin\bash -c 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin mkpasswd -l'>%SystemDrive%\cygwin\etc\passwd

%SystemDrive%\cygwin\usr\bin\sleep 1

REM %SystemDrive%\cygwin\bin\bash -c 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin /usr/bin/ssh-host-config -y -c "ntsecbinmode tty" -w "abc&&123!!" '
%SystemDrive%\cygwin\bin\bash -c 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin /usr/bin/ssh-host-config -y -c "ntsec tty" -w "abc&&123!!" '

%SystemDrive%\cygwin\usr\bin\sleep 2 

cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall add rule name="SSHD" dir=in action=allow program="c:\cygwin\usr\sbin\sshd.exe" SSHD enable=yes

cmd /c if exist %Systemroot%\system32\netsh.exe netsh advfirewall firewall add rule name="ssh" dir=in action=allow protocol=TCP localport=22

%SystemDrive%\cygwin\usr\bin\sleep 2

net start sshd

cmd /c %SystemDrive%\cygwin\bin\bash -c  'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin source /etc/profile'

# Fix corrupt recycle bin
# http://www.winhelponline.com/blog/fix-corrupted-recycle-bin-windows-7-vista/
cmd /c rd /s /q c:\$Recycle.bin

cmd /c %SystemDrive%\cygwin\bin\bash -c 'PATH=/usr/local/bin:/usr/bin:/bin:/usr/X11R6/bin echo "yes" | /usr/bin/cyglsa-config'

set /p Ready=Ready to reboot:

cmd /c shutdown /s /t 10 /f /d p:4:1 /c \"Vagrant Shutdown\"


