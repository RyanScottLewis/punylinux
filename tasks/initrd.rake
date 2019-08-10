directory paths.initrd.dirname

dependencies = [
  packages.install_paths,
  paths.fs_targets.split,
  paths.initrd.dirname
].flatten

exclude = paths.initrd.value.gsub(/#{paths.build_root}\/?/, '')

file paths.initrd => dependencies do
  sh <<~EOS
    pushd '#{paths.build_root}' > /dev/null
    find . -print -not -path '#{exclude}' | cpio -o -H newc | gzip -9 > initrd
    popd > /dev/null
    mv '#{paths.build_root.join('initrd')}' '#{paths.initrd}'
  EOS
end

