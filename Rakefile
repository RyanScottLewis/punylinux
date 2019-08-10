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

desc 'See: run:package'
task default: 'run:package'

# Namespace exists because Rake is stupid (well, Rake is based on Make, which is also stupid in this
# same way...) There is no distinction between 'tasks' and 'files'/'directory'. So, if I have a file
# named 'foo', a directory 'foo/' and a task 'foo'; then I call `rake foo`, what in the world
# happens?
#
# In this case, we have a task `build` and a directory `build` (like almost /all/ build automation
# scripts I write.) One workaround is to define & refer to directories with a `/` suffix, i.e. `foo/`
# This is fine and dandy for simple projects, however Rake breaks out `directory` in an interesting
# way. `directory 'foo/bar/'` ends up writing a "file" task for `foo/bar/` and `foo` which calls
# `mkdir -p`. You will notice that the automatically generated file task for the parent directory
# has NO `/` suffix. Rake gives no fucks about your conventions, only it's own.
#
# Therefore, instead of having conflicting task names for `build` or whatever others may come up in
# the future, functional tasks are defined here and file/directory tasks are defined normally in the
# global namespace as normal.

namespace :run do

  desc 'List all paths & packages'
  task :list do # TODO: Formatter or Printer classes
    puts 'Paths'
    longest_path_name = paths.map(&:name).map(&:length).max
    longest_path_path = paths.map(&:path).map(&:to_s).map(&:length).max # TODO: path... path? path_path.. C'mon son
    paths.each do |path|
      puts "  %s = %s # %s" % [
        path.name.to_s.ljust(longest_path_name),
        path.to_s.ljust(longest_path_path), # TODO: PATH PATH!!
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

  desc 'Install all package builds'
  task package: packages.install_paths

  #desc 'Generate ISO image'
  #task generate_iso: [:compress, packages.syslinux.] do

  #end

  desc "Generate dependency graph of rake tasks"
  task task_graph: paths.task_graph

end


# == Rules =========================================================================================

paths.task_pattern.glob.each do |path|
  load(path)
end


