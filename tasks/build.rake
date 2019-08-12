packages.each do |package|

  directory package.lock_path

  file package.build_lock_path => [package.lock_path, package.build_path] do
    instance_exec(package, &package.on_build) if package.on_build?
    sh "touch '#{package.build_lock_path}'"
  end

end

