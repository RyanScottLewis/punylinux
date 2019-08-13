# Package builds directory
directory paths.builds

packages.each do |package|

  # Retrieve archive
  directory package.archive_path.dirname

  file package.archive_path => package.archive_path.dirname do
    if package.archive.file? # Copy the file at the archive source URI's path to the packages archive path
      cp package.archive.path, package.archive_path
    else # TODO: download package.archive.uri, package.archive_path
      sh("curl -L '#{package.archive.uri}' --output '#{package.archive_path}'")
    end
  end

  # Decompress archive
  dependencies = [package.archive_path, paths.builds]
  dependencies << package.checksum_lock_path  if package.checksum?
  dependencies << package.signature_lock_path if package.signature?

  directory package.build_path => dependencies do
    sh("tar -xf '#{package.archive_path}' -C '#{paths.builds}'")
  end

end

