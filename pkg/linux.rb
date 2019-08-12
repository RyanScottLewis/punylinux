name      :linux
version   '5.2.5'
archive   "https://kernel.org/pub/linux/kernel/v#{version.split(?.).first}.x/linux-#{version}.tar.xz"
checksum  'c645402843f90a69426975f8923923dfc6edebb5d1bc0092560ffb7135d3cd96'
signature archive.gsub(/xz$/, 'sign')

files     %W(
  /boot/vmlinuz
)

on_verify do |package|
  decompressed_path = package.archive_path.sub_ext('')
  sh "xz --keep --decompress '#{package.archive_path}'" unless decompressed_path.exist?
  package.archive_path = decompressed_path

  sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
end

on_build do |package|
  jobs = `nproc`.to_i

  sh <<~EOS
    cd '#{package.build_path}'

    make defconfig

    # Enable initial ram disk and /dev/ram0 support
    sed -E -i 's/^(# )?(CONFIG_BLK_DEV_(RAM|INITRD)).+$/\\2=y/g' .config

    # Set number of RAM disk devices
    echo -e 'CONFIG_BLK_DEV_RAM_COUNT=1' >> .config

    # RAM disk size (in kilobytes)
    echo -e 'CONFIG_BLK_DEV_RAM_SIZE=8192' >> .config

    make -j#{jobs}
  EOS
end

on_install do |package|
  cp paths.linux_kernel, paths.os_kernel
end

