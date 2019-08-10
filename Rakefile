$LOAD_PATH.unshift(File.expand_path(File.join("..", "lib"), __FILE__))
require 'bundler/setup'
require 'rake/clean'
require 'package/import'
require 'path/import'

# == Paths =========================================================================================

FHS      = %w(bin boot dev etc lib proc sbin sys tmp usr/bin usr/sbin)
FHS_GLOB = "{#{FHS.join(?,)}}"

# Descriptive paths
path name: :build,                                                                       description: 'Linux root, ISO image root, etc.'
path name: :doc,                                                                         description: 'Project documentation'
path name: :lib,                                                                         description: 'Library sources'
path name: :pkg,                                                                         description: 'Package definitions'
path name: :src,                                                                         description: 'Project sources'
path name: :tmp,                                                                         description: 'Temporary file storage'
path name: :var,                                                                         description: 'Variable file storage'

path name: :fs,                  path: paths.src.join('fs'),                             description: 'Files to import into the Linux root path'
path name: :linux_config_source, path: paths.src.join('linux', 'config'),                description: 'Linux build configuration source'
path name: :linux_config,        path: -> { packages.linux.build_path.join('.config') }, description: 'Linux build configuration target'

path name: :builds,              path: paths.var.join('builds'),                         description: 'Package builds'
path name: :sources,             path: paths.var.join('sources'),                        description: 'Package sources'

path name: :task_graph,          path: paths.doc.join('task_graph.png'),                 description: 'Rake task dependency graph'

# Undescriptive paths
path name: :rakefile,   path: 'Rakefile'

path name: :build_root, path: paths.build.join('root') # TODO: Rename to just `root`
path name: :boot,       path: paths.build_root.join('boot')
path name: :initrd,     path: paths.boot.join('initrd.img') # TODO: Use .gz
path name: :kernel,     path: -> { packages.linux.build_path.join(*%w[arch x86 boot bzImage]) } # TODO: Use `uname -m`

path name: :tasks,      path: paths.lib.join('tasks').join('**', '*.{rake,rb}')
path name: :fhs_paths,  path: paths.build_root.join(FHS_GLOB)

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

desc 'See: run:initrd'
task default: 'run:initrd'

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
    descriptive_paths   = paths.with_descriptions
    name_justification  = descriptive_paths.name_justification
    value_justification = descriptive_paths.value_justification

    descriptive_paths.each do |path|
      puts "  %s = %s # %s" % [
        path.name.to_s.ljust(name_justification),
        path.value.to_s.ljust(value_justification),
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

  # TODO: Why do I even need these? They were more for debugging...
  # I guess it's nice to have the option

  desc 'Download all package sources'
  task download: packages.archive_paths

  desc 'Check all package checksums'
  task check: packages.checksum_lock_paths

  desc 'Verify all package signatures'
  task verify: packages.signature_lock_paths

  desc 'Build all package sources'
  task build: packages.build_lock_paths

  desc 'Install all package builds'
  task install: packages.install_paths

  desc 'Generate initial ramdisk'
  task initrd: paths.initrd

  #desc 'Generate ISO image'
  #task generate_iso: [:compress, packages.syslinux.] do

  #end

  desc "Generate dependency graph of rake tasks"
  task task_graph: paths.task_graph

end


# == Rules =========================================================================================

paths.tasks.glob.each do |path|
  load(path)
end

