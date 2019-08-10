packages.each do |package|

  # Retrieve archive
  directory package.archive_path.dirname

  file package.archive_path => package.archive_path.dirname do
    if package.archive.file?
      sh("cp '#{package.archive.path}' '#{package.archive_path}'")
    else
      sh("curl -L '#{package.archive.uri}' --output '#{package.archive_path}'")
    end
  end

  # Decompress archive
  dependencies = [package.archive_path]
  dependencies << package.checksum_lock_path  if package.checksum?
  dependencies << package.signature_lock_path if package.signature?

  directory package.build_path => dependencies do
    mkdir_p package.build_path
    sh("tar -xf '#{package.archive_path}' -C '#{paths.builds}'")
  end

end

