[
  path.isolinux_image,
  path.isolinux_ldlinux,
  path.isolinux_config
].each do |path|
  file path => packages.syslinux.build_lock_path
end

