#!/bin/sh
# TODO: THIS FILE IS TEMP FOR DEBUGGING N TESTING N SUCH

set -x

rm -f build/initrd.gz
rake

rm -rf build/punylinux-0.0.1.iso build/iso

#cp -a build/root/. build/iso/
mkdir -p build/iso/images
cp -a build/root/boot/vmlinuz build/iso/images/punylinux
cp -a build/initrd.gz build/iso/

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

