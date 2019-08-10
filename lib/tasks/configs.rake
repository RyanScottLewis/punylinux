# Generate Linux build configuration
directory paths.linux_config_source.dirname

file paths.linux_config_source => paths.linux_config_source.dirname do
  sh <<~EOS
    pushd '#{packages.linux.build_path}'
    make defconfig
    popd

    mv '#{packages.linux.build_path.join('.config')}' '#{paths.linux_config_source}'

    # Enable initial ram disk and /dev/ram0 support
    sed -E -i 's/^(# )?(CONFIG_BLK_DEV_(RAM|INITRD)).+$/\\2=y/g' '#{paths.linux_config_source}'
  EOS
end

# Copy configuration into the Linux package's build path
file paths.linux_config => [packages.linux.build_path, paths.linux_config_source] do |task|
  cp paths.linux_config_source, paths.linux_config
end

