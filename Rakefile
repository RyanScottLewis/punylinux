$LOAD_PATH.unshift(File.expand_path(File.join("..", "lib"), __FILE__))
require 'bundler/setup'
require 'rake/clean'
require 'package/import'
require 'path/import'

# == Paths =========================================================================================
# Usage:
#   path :foo                                       # paths.foo => 'foo'
#   path :bar, 'foo/bar'                            # paths.bar => 'foo/bar'
#   path(:baz) { some_global_not_yet_defined.path } # paths.baz => 'value_of_global' # Lazily-defined

path :rakefile, 'Rakefile'                                             # This Rakefile

path :build                                                            # Linux root, ISO image root, etc.
path :doc                                                              # Project documentation
path :lib                                                              # Library sources (Ruby code for this Rakefile)
path :pkg                                                              # Package definitions
path :src                                                              # Project sources
path :tmp                                                              # Temporary file storage
path :var                                                              # Variable file storage

path :fs,                  paths.src.join('fs')                        # Files to import into the Linux root path
path :linux_config_source, paths.src.join('linux', 'config')           # Linux build configuration source
path(:linux_config)      { packages.linux.build_path.join('.config') } # Linux build configuration target

path :builds,              paths.var.join('builds')                    # Package builds
path :sources,             paths.var.join('sources')                   # Package sources

path :build_root, paths.build.join('root')                             # Linux root path - /
path :boot,       paths.build_root.join('boot')                        # Linux root path - boot/
path :initrd,     paths.boot.join('initrd.img')                        # Linux root path - boot/initrd.img # TODO: Use initrd.gz

path :tasks,        paths.lib.join('tasks')                            # Rake tasks directory
path :task_pattern, paths.tasks.join('**', '*.{rake,rb}')              # Rake tasks glob pattern
path :task_graph,   paths.doc.join('task_graph.png')                   # Rake task dependency graph

# == Packages ======================================================================================

# Load all package specifications
load_results = Package.load_directory(paths.pkg)

if load_results.has_failures?
  puts "WARN: Packages failed:"
  puts load_results.error_messages.lines.map { |line| '  ' + line }.join
end

packages.with_paths!(paths)

# == Clean =========================================================================================

CLEAN.include paths.linux_config_source
CLEAN.include paths.sources
CLEAN.include paths.tmp
CLEAN.include paths.task_graph

CLOBBER.include paths.build
CLOBBER.include paths.var

# == Tasks =========================================================================================

desc 'See: package'
task default: :package

desc 'List all paths & packages'
task :list do # TODO: Formatter or Printer classes
  puts 'Paths'
  longest_path_name = paths.map(&:name).map(&:length).max
  paths.each do |path|
    puts "  %s = %s" % [path.name.to_s.ljust(longest_path_name), path.path]
  end

  puts '', 'Packages'
  longest_package_name    = packages.map(&:name).map(&:length).max
  longest_package_version = packages.map(&:version).map(&:length).max
  packages.each do |package|
    puts "  %s %s = %s" % [
      package.name.to_s.ljust(longest_package_name),
      package.version.ljust(longest_package_version),
      package.archive.uri
    ]
  end
end

desc 'Download all package sources'
task download: packages.archive_paths

desc 'Check all package checksums'
task check: packages.checksum_lock_paths

desc 'Verify all package signatures'
task verify: packages.signature_lock_paths

desc 'Build all package sources'
task build: packages.build_lock_paths

#desc 'Install all package builds'
#task package: packages.build_files

#desc 'Generate ISO image'
#task generate_iso: [:compress, packages.syslinux.] do

#end

desc "Generate dependency graph of rake tasks"
task task_graph: paths.task_graph



# == Rules =========================================================================================

# =- Directories -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

directory paths.boot.to_dir
directory paths.doc.to_dir
directory paths.tmp.to_dir

directory paths.builds.to_dir
directory paths.sources.to_dir

directory paths.linux_config_source.dirname.to_dir
directory paths.build_root.to_dir

packages.each do |package|
  directory package.lock_path
end

# =- Files -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

paths.task_pattern.glob.each do |path|
  load(path)
end


