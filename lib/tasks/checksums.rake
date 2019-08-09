packages.with_checksums.each do |package|

  # Retrieve/generate checksum
  file package.checksum_path => [package.archive_path, paths.sources.to_dir] do
    if package.checksum.file?
      sh("cp '#{package.checksum.path}' '#{package.checksum_path}'")
    elsif package.checksum.internal?
      package.checksum_path.open('w+') do |file|
        contents = "%s %s" % [package.checksum.value, package.archive.basename]

        file.write(contents)
      end
    else
      sh("curl -L '#{package.checksum.uri}' --output '#{package.checksum_path}'")
    end
  end

  # Verify checksum
  file package.checksum_lock_path => [package.checksum_path, package.lock_path] do |task|
    sh "cd '#{paths.sources}' && sha256sum --quiet --check '#{package.checksum_path.basename}'"
    sh "touch '#{package.checksum_lock_path}'"
  end

end

