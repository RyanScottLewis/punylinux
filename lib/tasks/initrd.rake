directory paths.initrd.dirname

dependencies = [
  paths.initrd.dirname,
  packages.install_paths
].flatten

exclude = paths.initrd.value.gsub(/#{paths.build_root}\/?/, '')

file paths.initrd => dependencies do
  sh <<~EOS
    find '#{paths.build_root}' -print -not -path '#{exclude}' | cpio -o -H newc | gzip -9 > '#{paths.initrd}'
  EOS
end

