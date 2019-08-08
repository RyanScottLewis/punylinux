packages.each do |package|
  dependencies = []
  dependencies << paths.linux_config if package.name == :linux

  file package.build_lock_path => dependencies do
    instance_exec(package, &package.on_build) if package.on_build?
    sh "touch '#{package.build_lock_path}'"
  end
end

