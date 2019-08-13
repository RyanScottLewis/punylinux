name      :linux
version   '5.2.5'
archive   "https://kernel.org/pub/linux/kernel/v#{version.split(?.).first}.x/linux-#{version}.tar.xz"
checksum  'c645402843f90a69426975f8923923dfc6edebb5d1bc0092560ffb7135d3cd96'
signature archive.gsub(/xz$/, 'sign')

on_verify do |package|
  sh "xz -cd '#{package.archive_path}' | gpg --verify '#{package.signature_path}' -"
end

on_build do |package|
  config_path = package.build_path.join('.config')

  unless config_path.exist?
    cd(package.build_path) { make :defconfig }

    update_config(config_path,
      'CONFIG_BLK_DEV_INITRD'    => ?y,   # Enable initial ramdisk
      'CONFIG_BLK_DEV_RAM'       => ?y,   # Enable /dev/ram
      'CONFIG_BLK_DEV_RAM_COUNT' => 1,    # /dev/ram device count
      'CONFIG_BLK_DEV_RAM_SIZE'  => 8192, # RAM disk size (in kilobytes)
    )
  end

  cd(package.build_path) { make }
end

on_install do |package|
  cp paths.linux_kernel, paths.os_kernel
end

files %W(
  /boot/vmlinuz
)

