#!/bin/bash
 
set -e
set -x

ARCH=x86_64
VERSION=6
FLAVOR=server

KSNAME=ECASP
KSFILE=ecasp.ks
PUBKEYFILE=ecasp.pub

ADDPACKAGES=""
RMPACKAGES="kde* qt*" 
ISOURL=rsync://mirror.anl.gov/scientific-linux/$VERSION/$ARCH/iso/SL-6?-$ARCH-*-boot.iso

WORKDIR=$(pwd)

#cd /tmp
rsync --progress -vaLz $ISOURL .
ISONAME=$(ls SL-$VERSION?-$ARCH-*-boot.iso)
rm -rf cd && mkdir cd
7z x $ISONAME -ocd >/dev/null 
chmod -R +w cd 
rm -rf cd/'[BOOT]'
echo "	1. Add a custom autoinstall option to the bootloader"

cat > isolinux.cfg <<EOF
default custom
label custom
	menu label ^$KSNAME Server
	menu default
	kernel vmlinuz
	append initrd=initrd.img ks=cdrom://ks.cfg
EOF

cat cd/isolinux/isolinux.cfg | sed 's/menu default//' >> isolinux.cfg
sed -i 's/default install//' isolinux.cfg
cp -f isolinux.cfg cd/isolinux/isolinux.cfg

echo "	2. Setup isolinux to automatically run the autoinstall after a 10 sec delay"

sed  's/timeout.*$/timeout\ 50/' ./cd/isolinux/isolinux.cfg > isolinux.cfg
cp -f isolinux.cfg cd/isolinux/isolinux.cfg

#echo "	3. Extract the initrd"

#rm -rf initrd && mkdir initrd
#cd initrd 
#lzcat ../cd/isolinux/initrd.img | cpio -idum 2>/dev/null || true
#cd ..

echo "	4. Insert the public key into the kickstart file"

PUBKEY=$(cat $WORKDIR/$PUBKEYFILE)
cat $WORKDIR/$KSFILE | sed "s#@PUBKEY@#$PUBKEY#" > ks.cfg
#cp -f ks.cfg initrd/ks.cfg
cp -f ks.cfg cd/ks.cfg

#echo "	6. Install all dependencies"

#cd cd/Packages/ && yumdownloader $ADDPACKAGES

cd ..

echo "  7. Delete extraneous Packages"
cd Packages && rm -rf $RMPACKAGES

cd ..

declare -x discinfo=`head -1 .discinfo`
createrepo --update --skip-stat -u "media://$discinfo" -g repodata/comps.xml .

cd ..

echo "	8. Generate ISO"

mkisofs -r -J -N -d -hide-rr-moved -b isolinux/isolinux.bin  \
  -no-emul-boot -boot-load-size 4       \
  -boot-info-table     \
  -c isolinux/boot.cat              \
  -o ./sl6-$KSNAME-$VERSION-$ARCH-mini.iso \
  cd/ 2> /dev/null 
