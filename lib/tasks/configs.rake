file paths.linux_config_source => paths.linux_config_source.dirname.to_dir do
  sh <<~EOS
    cd '#{packages.linux.build_path}'
    make defconfig
    make menuconfig
    mv .config '#{paths.linux_config_source.expand_path}'
  EOS

  # TODO: CONFIG_BLK_DEV_RAM=y
  # This enables /dev/ram0 as required by initrd (CONFIG_BLK_DEV_INITRD)
end

file paths.linux_config => [packages.linux.build_path, paths.linux_config_source] do |task|
  cp paths.linux_config_source, paths.linux_config
end

