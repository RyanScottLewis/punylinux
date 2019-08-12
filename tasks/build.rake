packages.each do |package|

  directory package.lock_path

  dependencies = [package.lock_path, package.build_path]
  dependencies << paths.linux_config   if package.name == :linux
  dependencies << paths.busybox_config if package.name == :busybox

  file package.build_lock_path => dependencies do
    instance_exec(package, &package.on_build) if package.on_build?
    sh "touch '#{package.build_lock_path}'"
  end

end

