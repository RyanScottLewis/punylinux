packages.with_files.each do |package|
  package.install_paths.each do |path|
    file path => paths.build_root do
      instance_exec(package, &package.on_install) if package.on_install?
    end
  end
end

