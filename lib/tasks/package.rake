packages.with_files.each do |package|
  package.build_files.each do |path|
    file path => paths.build_root.to_dir do
      instance_exec(package, &package.on_package) if package.on_package?
    end
  end
end

