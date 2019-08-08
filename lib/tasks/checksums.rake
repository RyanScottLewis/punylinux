# Generate checksum file
packages.with_internal_checksums.each do |package|
  file package.checksum_path => paths.sources.to_dir do
    package.checksum_path.open('w+') do |file|
      contents = "%s %s" % [package.checksum, package.archive_basename]

      file.write(contents)
    end
  end
end

# Download checksum
packages.with_external_checksums.each do |package|
  file package.checksum_path => [package.archive_path, paths.sources.to_dir] do
    download package.checksum, package.checksum_path
  end
end

# Verify checksum
packages.with_checksums.each do |package|
  file package.checksum_lock_path => [package.archive_path, package.checksum_path] do |task|
    sh "cd '#{paths.sources}' && sha256sum --quiet --check '#{package.checksum_path.basename}'"
    sh "touch '#{package.checksum_lock_path}'"
  end
end

