# Download package signature
packages.with_signatures.each do |package|
  file package.signature_path => [package.archive_path, paths.sources.to_dir]
end

# Verify signatures
packages.with_signatures.each do |package|
  file package.signature_lock_path => [package.archive_path, package.signature_path] do |task|
    if package.on_verify?
      instance_exec(package, &package.on_verify)
    else
      sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
    end

    sh "touch '#{package.signature_lock_path}'"
  end
end

