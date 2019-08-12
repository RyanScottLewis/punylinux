#!/bin/sh
# TODO: THIS FILE IS TEMP FOR DEBUGGING N TESTING N SUCH

set -x

rm -rf build

rake

cp -a build/initrd.cpio.gz build/iso/

mkdir -p build/iso/images
cp var/builds/linux-5.2.5/arch/`uname -m`/boot/bzImage build/iso/images/punylinux
cp -a build/initrd.cpio.gz build/iso/

mkdir -p build/iso/isolinux
cp var/builds/syslinux-6.03/bios/core/isolinux.bin build/iso/isolinux/
cp var/builds/syslinux-6.03/bios/com32/elflink/ldlinux/ldlinux.c32 build/iso/isolinux/
cp src/iso/isolinux.cfg build/iso/isolinux/isolinux.cfg

genisoimage \
  -b isolinux/isolinux.bin \
  -boot-info-table \
  -boot-load-size 4 \
  -c isolinux/boot.cat \
  -cache-inodes \
  -full-iso9660-filenames \
  -input-charset UTF8 \
  -joliet \
  -no-emul-boot \
  -o build/punylinux-0.0.1.iso \
  -rational-rock \
  -volid "PunyLinux ISO" \
  build/iso

