name      :linux
version   '5.2.5'
archive   "https://kernel.org/pub/linux/kernel/v#{version.split(?.).first}.x/linux-#{version}.tar.xz"
checksum  'c645402843f90a69426975f8923923dfc6edebb5d1bc0092560ffb7135d3cd96'
signature archive.gsub(/xz$/, 'sign')
files     %W(
  /boot/vmlinuz
)

on_verify do |package|
  decompressed_path = package.archive_path.sub_ext('')
  sh "xz --keep --decompress '#{package.archive_path}'" unless decompressed_path.exist?
  package.archive_path = decompressed_path

  sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
end

on_build do |package|
  sh <<~EOS
    cd '#{package.build_path}'
    make -j#{`nproc`}
  EOS
end

on_install do |package|
  sh <<~EOS
    cp '#{paths.kernel}' '#{package.install_paths.last}'
  EOS
end

