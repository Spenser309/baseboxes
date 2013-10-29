#!/bin/bash
 
set -e
#set -x

ARCH=amd64
VERSION=precise

SEEDNAME=ECASP
SEEDFILE=ecasp.seed
PUBKEYFILE=ecasp.pub

ISOURL=rsync://mirror.anl.gov/ubuntu/dists/$VERSION/main/installer-$ARCH/current/images/netboot/mini.iso

WORKDIR=$(pwd)

#cd /tmp
rsync -a $ISOURL  original.iso
rm -rf cd && mkdir cd
bsdtar -C cd -xf original.iso 
chmod -R +w cd 

echo "	1. Add a custom autoinstall option to the bootloader"

echo "default custom" > txt.cfg
echo "label custom" >> txt.cfg
echo "	menu label ^$SEEDNAME Server" >> txt.cfg
echo "	menu default" >> txt.cfg
echo "	kernel linux" >> txt.cfg
echo "	append auto=true initrd=initrd.gz -- quiet" >> txt.cfg
cat cd/txt.cfg | sed 's/menu default//' >> txt.cfg
sed -i 's/default install//' txt.cfg
cp -f txt.cfg cd/txt.cfg


echo "	2. Setup isolinux to automatically run the autoinstall after a 10 sec delay"

sed  's/timeout\ 0/timeout\ 50/' ./cd/isolinux.cfg > isolinux.cfg
cp -f isolinux.cfg cd/isolinux.cfg


echo "	3. Extract the initrd"

mkdir cd/initrd
cd cd/initrd 
zcat ../initrd.gz | cpio -i 2>/dev/null || true
cd ../..


echo "	4. Insert the public key into the preseed file"

PUBKEY=$(cat $WORKDIR/$PUBKEYFILE)
cat $WORKDIR/$SEEDFILE | sed "s#@PUBKEY@#$PUBKEY#" > preseed.cfg
cp -f preseed.cfg cd/initrd/preseed.cfg


echo "	5. Recompress initrd"

cd cd/initrd && find . -print0 | cpio -0 -H newc -o 2>/dev/null | gzip -c > ../../initrd.gz 2>/dev/null 
cd ../..
cp -f initrd.gz cd/
rm -rf cd/initrd

echo "	6. Generate new md5sum"
cd cd
[ -e md5sum.txt ] && rm md5sum.txt
find -type f -print0 | xargs -0 md5sum | grep -v boot.cat > md5sum.txt
cd ..


echo "	7. Generate ISO"

mkisofs -r -J -l -b isolinux.bin  \
  -no-emul-boot -boot-load-size 4       \
  -boot-info-table -z -iso-level 4      \
  -c boot.cat              \
  -o ./ubuntu-$SEEDNAME-$VERSION-$ARCH-mini.iso \
  cd/ 2> /dev/null 

