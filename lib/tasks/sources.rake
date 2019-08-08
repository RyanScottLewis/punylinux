packages.each do |package|

  # Download source archive
  file package.archive_path => paths.sources.to_dir do
    download package.archive, archive_path
  end

  # Decompress source archives
  dependencies = [package.archive_path, paths.builds.to_dir]
  dependencies << package.checksum_lock_path  if package.checksum?
  dependencies << package.signature_lock_path if package.signature?

  directory package.build_path => dependencies do
    sh "tar -xf '#{package.archive_path}' -C '#{paths.builds}'"
  end

end

