packages.with_signatures.each do |package|

  # Retrieve/generate signature
  directory package.signature_path.dirname

  file package.signature_path => [package.archive_path, package.signature_path.dirname] do
    if package.signature.file?
      sh("cp '#{package.signature.path}' '#{package.signature_path}'")
    elsif package.signature.internal?
      package.signature_path.open('w+') do |file|
        file.write(package.signature.value)
      end
    else
      sh("curl -L '#{package.signature.uri}' --output '#{package.signature_path}'")
    end
  end

  # Verify signature
  file package.signature_lock_path => [package.signature_path, package.lock_path] do |task|
    if package.on_verify?
      instance_exec(package, &package.on_verify)
    else
      sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
    end

    sh "touch '#{package.signature_lock_path}'"
  end

end

