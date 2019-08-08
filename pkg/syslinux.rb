# SYSLINUX is used to generate images for distribution of the final linux build.
# This package exists to aquire SYSLINUX only, but is not "installed" into the build.
# TODO: Is there a better way to do this?

name      :syslinux
version   '6.03'
archive   "https://kernel.org/pub/linux/utils/boot/syslinux/syslinux-#{version}.tar.xz"
checksum  '26d3986d2bea109d5dc0e4f8c4822a459276cf021125e8c9f23c3cca5d8c850e'
signature archive.gsub(/xz$/, 'sign')

on_verify do |package|
  decompressed_path = package.archive_path.sub_ext('')
  sh "xz --keep --decompress '#{package.archive_path}'" unless decompressed_path.exist?
  package.archive_path = decompressed_path

  sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
end

