packages.with_files.each do |package|

  package.install_paths.each do |path|
    directory path.dirname

    file path => path.dirname do
      instance_exec(package, &package.on_install) if package.on_install?
    end
  end

end

