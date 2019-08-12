# Generate Linux build configuration
directory paths.linux_config_source.dirname

file paths.linux_config_source => [packages.linux.build_path, paths.linux_config_source.dirname] do
  sh <<~EOS
    pushd '#{packages.linux.build_path}' > /dev/null
    make defconfig
    popd > /dev/null

    mv '#{packages.linux.build_path.join('.config')}' '#{paths.linux_config_source}'

    # Enable initial ram disk and /dev/ram0 support
    sed -E -i 's/^(# )?(CONFIG_BLK_DEV_(RAM|INITRD)).+$/\\2=y/g' '#{paths.linux_config_source}'

    # Set number of RAM disk devices
    echo -e 'CONFIG_BLK_DEV_RAM_COUNT=1' >> '#{paths.linux_config_source}'

    # RAM disk size (in kilobytes)
    echo -e 'CONFIG_BLK_DEV_RAM_SIZE=8192' >> '#{paths.linux_config_source}'
  EOS
end

# Copy configuration into the Linux package's build path
file paths.linux_config => [packages.linux.build_path, paths.linux_config_source] do |task|
  cp paths.linux_config_source, paths.linux_config
end

# Generate Busybox build configuration
directory paths.busybox_config_source.dirname

file paths.busybox_config_source => [packages.busybox.build_path, paths.busybox_config_source.dirname] do
  sh <<~EOS
    pushd '#{packages.busybox.build_path}' > /dev/null
    make defconfig
    popd > /dev/null

    mv '#{packages.busybox.build_path.join('.config')}' '#{paths.busybox_config_source}'

    # Enable static linking
    sed -E -i 's/^(# )?(CONFIG_STATIC).+$/\\2=y/g' '#{paths.busybox_config_source}'
  EOS
end

# Copy configuration into the Busybox package's build path
file paths.busybox_config => [packages.busybox.build_path, paths.busybox_config_source] do |task|
  cp paths.busybox_config_source, paths.busybox_config
end

