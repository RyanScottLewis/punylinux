directory paths.initrd.dirname

dependencies = [
  packages.install_paths,
  paths.fs_targets.split,
  paths.initrd.dirname
].flatten

file paths.initrd => dependencies do
  sh <<~EOS
    pushd '#{paths.build_root}' > /dev/null
    find . | fakeroot cpio -o -H newc -R root:root | gzip -9 > initrd
    popd > /dev/null
    mv '#{paths.build_root.join('initrd')}' '#{paths.initrd}'
  EOS
end

