packages.with_files.each do |package|
  package.install_files.each do |path|
    file path => paths.build_root do
      instance_exec(package, &package.on_package) if package.on_package?
    end
  end
end

