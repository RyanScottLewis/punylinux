$LOAD_PATH.unshift(File.expand_path(File.join("..", "lib"), __FILE__))
require "rake/clean"
require "coreext/pathname"
require "package/import"
require "path/import"

# TODO: Move to file
def download(url, path)
  sh "curl -L '#{url}' --output '#{path}'"
end

# == Paths =========================================================================================

path :build
path :lib
path :src
path :tmp
path :var
path :pkg

path :fs,                  paths.src.join('fs')
path :linux_config_source, paths.src.join('linux', 'config')
path(:linux_config)        { packages.linux.build_path.join('.config') }

path :builds,   paths.var.join('builds')
path :sources,  paths.var.join('sources')

path :build_root, paths.build.join('root')
path :boot,       paths.build_root.join('boot')
path :initrd,     paths.boot.join('initrd.img')

# == Packages ======================================================================================

# Load all packages files and use each individual file contents to define a package
paths.pkg.join('*.rb').glob.each do |path|
  package { instance_eval(path.read, path.to_s) }
end

# Set up all automatic package attributes
packages.each do |package|
  package.identifier          = [package.name, package.version].join(?-)
  package.archive_path        = paths.sources.join(package.archive_basename)
  package.checksum_path       = paths.sources.join(package.identifier).append_ext('.checksum')  if package.checksum?
  package.signature_path      = paths.sources.join(package.identifier).append_ext('.signature') if package.signature?
  package.build_path          = paths.builds.join(package.identifier)
  package.lock_path           = paths.tmp.join(package.identifier)
  package.checksum_lock_path  = package.lock_path.join('checksum.lock')  if package.checksum?
  package.signature_lock_path = package.lock_path.join('signature.lock') if package.signature?
  package.build_lock_path     = package.lock_path.join('build.lock')
end

# == Clean =========================================================================================

CLEAN.include paths.linux_config_source
CLEAN.include paths.var

CLOBBER.include paths.build_root

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
directory paths.build_root.to_dir
directory paths.boot.to_dir
directory paths.linux_config_source.dirname.to_dir

# =- Files -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

paths.lib.join('tasks', '**', '*.{rake,rb}').glob.each do |path|
  load(path)
end


