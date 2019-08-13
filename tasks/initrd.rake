directory paths.os_initrd.dirname

dependencies = [
  packages.install_paths,
  paths.fs_targets.split,
  paths.os_fhs.explode,
  paths.os_kernel,
  paths.os_initrd.dirname
].flatten

file paths.os_initrd => dependencies do
  sh <<~EOS
    cd '#{paths.os_root}'
    find . -path "./*" -not -path './#{paths.os_initrd.sub(paths.os_root.to_s + ?/, '')}' | fakeroot cpio -o -H newc -R root:root | gzip -9 > initrd
    mv initrd '#{paths.os_initrd.expand_path}'
  EOS
end

