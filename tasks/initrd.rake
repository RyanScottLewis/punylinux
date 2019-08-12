directory paths.os_initrd.dirname

dependencies = [
  packages.install_paths,
  paths.fs_targets.split,
  paths.os_initrd.dirname
].flatten

file paths.os_initrd => dependencies do
  sh <<~EOS
    pushd '#{paths.os_root}' > /dev/null
    find . | fakeroot cpio -o -H newc -R root:root | gzip -9 > initrd
    popd > /dev/null
    mv '#{paths.os_root.join('initrd')}' '#{paths.os_initrd}'
  EOS
end

