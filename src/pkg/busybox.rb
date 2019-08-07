name      :busybox
version   "1.31.0"
url       "https://busybox.net/downloads/busybox-#{version}.tar.bz2"
signature "#{url}.sig"
checksum  "#{url}.sha256"
files     paths.packages.join('busybox', 'files').read.lines.map(&:strip)

on_build do |package|
  sh <<~EOS
    cd '#{package.build_path}'
    make defconfig
    make
  EOS
end

on_package do |package|
  sh <<~EOS
    cd '#{package.build_path}'
    make install &> /dev/null
    chmod 4755 _install/bin/busybox
  EOS

  sh <<~EOS
    cp -a #{package.build_path}/_install/* '#{paths.build}'
    cd '#{paths.build}'
    rm linuxrc
    ln -sf busybox bin/init
  EOS
end

