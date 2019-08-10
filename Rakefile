$LOAD_PATH.unshift(File.expand_path(File.join("..", "lib"), __FILE__))
require 'bundler/setup'
require 'rake/clean'
require 'package/import'
require 'path/import'

# == Paths =========================================================================================

path name: :rakefile,            path: 'Rakefile',                                       description: 'The main Rakefile'

path name: :build,                                                                       description: 'Linux root, ISO image root, etc.'
path name: :doc,                                                                         description: 'Project documentation'
path name: :lib,                                                                         description: 'Library sources (Ruby code for this Rakefile)'
path name: :pkg,                                                                         description: 'Package definitions'
path name: :src,                                                                         description: 'Project sources'
path name: :tmp,                                                                         description: 'Temporary file storage'
path name: :var,                                                                         description: 'Variable file storage'

path name: :fs,                  path: paths.src.join('fs'),                             description: 'Files to import into the Linux root path'
path name: :linux_config_source, path: paths.src.join('linux', 'config'),                description: 'Linux build configuration source'
path name: :linux_config,        path: -> { packages.linux.build_path.join('.config') }, description: 'Linux build configuration target'

path name: :builds,              path: paths.var.join('builds'),                         description: 'Package builds'
path name: :sources,             path: paths.var.join('sources'),                        description: 'Package sources'

path name: :build_root,          path: paths.build.join('root'),                         description: 'Linux root path - /'
path name: :boot,                path: paths.build_root.join('boot'),                    description: 'Linux root path - boot/'
path name: :initrd,              path: paths.boot.join('initrd.img'),                    description: 'Linux root path - boot/initrd.img' # TODO: Use initrd.gz

path name: :tasks,               path: paths.lib.join('tasks'),                          description: 'Rake tasks directory'
path name: :task_pattern,        path: paths.tasks.join('**', '*.{rake,rb}'),            description: 'Rake tasks glob pattern'
path name: :task_graph,          path: paths.doc.join('task_graph.png'),                 description: 'Rake task dependency graph'

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
  longest_path_path = paths.map(&:path).map(&:to_s).map(&:length).max # TODO: path... path? path_path.. C'mon son
  paths.each do |path|
    puts "  %s = %s # %s" % [
      path.name.to_s.ljust(longest_path_name),
      path.path.to_s.ljust(longest_path_path), # TODO: PATH PATH!!
      path.description
    ]
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


