$LOAD_PATH.unshift(File.expand_path(File.join("..", "lib"), __FILE__))
require "rake/clean"
require "coreext/pathname"
require "package/import"
require "path/import"

# TODO:
# * rsync -a src/fs/ build/ # With ending slashes to merge into directory

# == Paths =========================================================================================

path :build
path :src
path :tmp
path :var

path :boot,     paths.build.join('boot')
path :builds,   paths.var.join('builds')
path :fs,       paths.src.join('fs')
path :initrd,   paths.boot.join('initrd.img')
path :packages, paths.src.join('pkg')
path :sources,  paths.var.join('sources')

path :linux_config_source, paths.src.join('linux', 'config')

# == Packages ======================================================================================
# Load all packages files and use each individual file contents to define a package

paths.packages.join('*.rb').glob.each do |path|
  package { instance_eval(path.read, path.to_s) }
end

# == Paths =========================================================================================
# Dependent on packages, so defined after them

# TODO: Define with a block to set path lazily
path :linux_config,   packages.linux.build_path.join('.config')
path :busybox_config, packages.busybox.build_path.join('.config')

# == Clean =========================================================================================

CLEAN.include paths.linux_config_source
CLEAN.include paths.var

CLOBBER.include paths.build

# == Tasks =========================================================================================

desc 'See: package'
task default: :package

task :debug do
  pp packages[1]
end

desc 'List all paths & packages'
task :list do
  puts 'Paths'
  longest_path_name = paths.map(&:name).map(&:length).max
  paths.each do |path|
    puts "  %s = %s" % [path.name.to_s.ljust(longest_path_name), path.value]
  end

  puts '', 'Packages'
  longest_package_name    = packages.map(&:name).map(&:length).max
  longest_package_version = packages.map(&:version).map(&:length).max
  packages.each do |package|
    puts "  %s %s = %s" % [
      package.name.to_s.ljust(longest_package_name),
      package.version.ljust(longest_package_version),
      package.url
    ]
  end
end

desc 'Download all package sources'
task download: packages.source_paths

desc 'Verify checksum on all package sources'
task check: packages.checksum_lock_paths

desc 'Verify signature on all package sources'
task verify: packages.signature_lock_paths

desc 'Decompress all package sources'
task decompress: packages.build_paths

desc 'Build all package sources'
task build: paths.build_lock_paths

desc 'Install all package builds'
task package: packages.build_files

#desc 'Generate ISO image'
#task generate_iso: [:compress, packages.syslinux.] do

#end

# == Rules =========================================================================================

# =- Directories -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

directory paths.sources.to_dir
directory paths.builds.to_dir
directory paths.build.to_dir
directory paths.boot.to_dir
directory paths.linux_config_source.dirname.to_dir

# =- Files -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

# -- Sources ---------------------------------------------------------------------------------------

packages.sources.each do |source|
  file source.path => paths.sources.to_dir do
    sh "cd '#{paths.sources}' && wget -q '#{source.url}'"
  end
end

packages.without_external_checksums.each do |package|
  file package.checksum_path => [package.archive_path, paths.sources.to_dir] do
    sh "cd '#{paths.sources}' && sha256sum '#{package.archive_path.basename}' > '#{package.checksum_path.basename}'"
  end
end

packages.with_external_checksums.each do |package|
  file package.checksum_path => [package.archive_path, paths.sources.to_dir]
end

packages.with_signatures.each do |package|
  file package.signature_path => [package.archive_path, paths.sources.to_dir]
end

packages.each do |package|
  directory package.build_path => [package.archive_path, package.checksum_lock_path, package.signature_lock_path, paths.builds.to_dir] do
    sh "tar -xf '#{package.archive_path}' -C '#{paths.builds}'"
  end
end

# -- Configs ---------------------------------------------------------------------------------------

file paths.linux_config_source => paths.linux_config_source.dirname.to_dir do
  sh <<~EOS
    cd '#{packages.linux.build_path}'
    make defconfig
    make menuconfig
    mv .config '#{paths.linux_config_source.expand_path}'
  EOS
end

file paths.linux_config => [packages.linux.build_path, paths.linux_config_source] do |task|
  cp paths.linux_config_source, task.name
end

file paths.busybox_config => [packages.busybox.build_path, paths.linux_config_source] do |task|
  cp paths.linux_config_source, task.name
end

# -- Locks -----------------------------------------------------------------------------------------

packages.with_checksums.each do |package|
  file package.checksum_lock_path => [package.archive_path, package.checksum_path] do |task|
    sh "cd '#{paths.sources}' && sha256sum --quiet --check '#{package.checksum_path.basename}'"
    sh "touch '#{package.checksum_lock_path}'"
  end
end

packages.with_signatures.each do |package|
  file package.signature_lock_path => [package.archive_path, package.signature_path] do |task|
    if package.verify?
      instance_exec(package, &package.on_verify)
    else
      sh "gpg --verify '#{package.signature_path}' '#{package.archive_path}'"
    end

    sh "touch '#{package.signature_lock_path}'"
  end
end

packages.each do |package|
  dependencies = []
  dependencies << package.checksum_lock_path  if package.checksum?
  dependencies << package.signature_lock_path if package.signature?
  dependencies << paths.linux_config          if package.name == :linux
  dependencies << paths.busybox_config        if package.name == :busybox

  file package.build_lock_path => dependencies do
    instance_exec(package, &package.on_build) if package.on_build?
    sh "touch '#{package.build_lock_path}'"
  end

  #file package.package_lock_path => [package.build_lock_path, paths.build.to_dir] do
    #instance_exec(package, &package.on_package) if package.on_package?
    #sh "touch '#{package.package_lock_path}'"
  #end

  #pp package.build_files

  #package.build_files.each do |path|
    ##p path
    ##file paths.build.join(path) => paths.build.to_dir do
      ##instance_exec(package, &package.on_package) if package.on_package?
    ##end
  #end if package.files?
end

packages.with_files.each do |package|
  package.build_files.each do |path|
    file path => paths.build.to_dir do
      instance_exec(package, &package.on_package) if package.on_package?
    end
  end
end

