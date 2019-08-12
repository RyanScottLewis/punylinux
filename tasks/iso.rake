namespace :iso do

  desc 'Generate ISO9660 bootable image'
  task build: paths.iso

  desc 'Compress ISO'
  task compress: paths.iso_xz

end

desc 'See: iso:compress'
task iso: 'iso:compress'

source_targets = {
  paths.os_initrd        => paths.iso_initrd,
  paths.os_kernel        => paths.iso_kernel,
  paths.isolinux_image   => paths.iso_isolinux_image,
  paths.isolinux_ldlinux => paths.iso_isolinux_ldlinux,
  paths.isolinux_config  => paths.iso_isolinux_config,
}

source_targets.each do |source, target|

  directory target.dirname

  file target => [source, target.dirname] do
    cp source, target
  end

end

directory paths.iso.dirname

dependencies = [source_targets.values, paths.iso.dirname].flatten
file paths.iso => dependencies do
  sh <<~EOS
    genisoimage \
      -b isolinux/isolinux.bin \
      -boot-info-table \
      -boot-load-size 4 \
      -c isolinux/boot.cat \
      -cache-inodes \
      -full-iso9660-filenames \
      -input-charset UTF8 \
      -joliet \
      -no-emul-boot \
      -o #{paths.iso} \
      -rational-rock \
      -volid "#{ISO_LABEL}" \
      '#{paths.iso_root}'
  EOS
end

directory paths.iso_xz.dirname

file paths.iso_xz => paths.iso do
  sh <<~EOS
    xz -9 --keep --force '#{paths.iso}'
  EOS
end
