name      :linux
version   '5.2.5'
archive   "https://kernel.org/pub/linux/kernel/v#{version.split(?.).first}.x/linux-#{version}.tar.xz"
checksum  'c645402843f90a69426975f8923923dfc6edebb5d1bc0092560ffb7135d3cd96'
signature archive.gsub(/xz$/, 'sign')
files     %W(
  /bin
  /boot
  /dev
  /etc
  /lib
  /proc
  /sbin
  /sys
  /tmp
  /usr
  /usr/bin
  /usr/sbin

  /boot/vmlinuz
)

on_verify do |package|
  decompressed_path = package.archive_path.sub_ext('')
  sh "xz --keep --decompress '#{package.archive_path}'" unless decompressed_path.exist?
  package.archive_path = decompressed_path

  sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
end

on_build do |package|
  sh <<~EOS
    cd '#{package.build_path}'
    make -j#{`nproc`}
  EOS
end

on_package do |package|
  puts "* Creating Linux Filesystem Hierarchy directories"
  sh <<~EOS
    mkdir -p #{package.build_files[0...-1].join(' ')}
  EOS

  puts "* Installing Linux"
  kernel_path = package.build_path.join('arch/x86/boot/bzImage')
  sh <<~EOS
    cp '#{kernel_path}' '#{package.build_files.last}'
  EOS

  puts "* Generating inital ramdisk"
  sh <<~EOS
    find '#{paths.build}' -print | cpio -o -H newc | gzip -9 > '#{paths.initrd}'
  EOS
end

