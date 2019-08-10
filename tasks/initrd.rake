directory paths.initrd.dirname

dependencies = [
  packages.install_paths,
  paths.fs_targets.split,
  paths.initrd.dirname
].flatten

file paths.initrd => dependencies do
  sh <<~EOS
    ln -sf '#{paths.build_root.join('bin', 'busybox')}' '#{paths.build_root.join('init')}'
    pushd '#{paths.build_root}' > /dev/null
    find . -print | cpio -o -H newc | gzip -9 > initrd
    popd > /dev/null
    rm -f '#{paths.build_root.join('init')}'
    mv '#{paths.build_root.join('initrd')}' '#{paths.initrd}'
  EOS
end

