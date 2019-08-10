packages.with_files.each do |package|

  package.install_paths.each do |path|
    directory path.dirname

    dependencies = []
    dependencies << package.build_lock_path
    dependencies += paths.fhs_paths.explode
    dependencies << path.dirname

    file path => dependencies do
      instance_exec(package, &package.on_install) if package.on_install?
    end
  end

end

