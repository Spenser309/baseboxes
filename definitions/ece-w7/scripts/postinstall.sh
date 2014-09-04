set -x

# Install rpm,apt-get like code for cygwin
# http://superuser.com/questions/40545/upgrading-and-installing-packages-through-the-cygwin-command-line
wget http://apt-cyg.googlecode.com/svn/trunk/apt-cyg
chmod +x apt-cyg
mv apt-cyg /usr/local/bin/

# 7zip will allow us to extract a file from an ISO
wget http://downloads.sourceforge.net/sevenzip/7z922-x64.msi
msiexec /qb /i 7z922-x64.msi

# Download Virtualbox Additions
VBOX_VERSION="$(cat /.vbox_version)" #"4.0.8"
wget http://download.virtualbox.org/virtualbox/$VBOX_VERSION/VBoxGuestAdditions_$VBOX_VERSION.iso

# Extract the installer from the ISO (WHY WHY WHY isn't this available not bundled within an ISO)
/cygdrive/c/Program\ Files/7-Zip/7z.exe x VBoxGuestAdditions_$VBOX_VERSION.iso VBoxWindowsAdditions-amd64.exe

# Mark Oracle as a trusted installer
#http://blogs.msdn.com/b/steverac/archive/2009/07/09/adding-certificates-to-the-local-certificates-store-and-setting-local-policy-using-a-command-line-system-center-updates-publisher-example.aspx

certutil -addstore -f "TrustedPublisher" a:oracle-cert.cer

# Install the Virtualbox Additions
./VBoxWindowsAdditions-amd64.exe /S


#Rather than do the manual install of ruby and chef, just use the opscode msi
curl -L http://downloads.puppetlabs.com/windows/puppet-3.3.1.msi -o puppet.msi
msiexec /qn /i puppet.msi

#http://www.msfn.org/board/topic/105277-howto-create-a-fully-up-to-date-xp-x64-dvd/

#Making aliases
cat <<EOF > $HOME/.bash_profile
alias gem="gem.bat"
alias ruby="ruby.exe"
alias puppet="puppet.bat"
alias irb="irb.bat"
alias facter="facter.bat" 
EOF


cat <<'EOF' > /bin/sudo
#!/usr/bin/bash
exec "$@"
EOF
chmod 755 /bin/sudo

# Reboot
# http://www.techrepublic.com/blog/datacenter/restart-windows-server-2003-from-the-command-line/245
#shutdown.exe /s /t 0 /d p:2:4 /c "Vagrant initial reboot"

