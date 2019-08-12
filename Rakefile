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
path name: :fs,                                                                          description: 'Files to import into the Linux root path'
path name: :tasks,                                                                       description: 'Rake tasks'

path name: :linux_config_source,   path: paths.src.join('linux', 'config'),                description: 'Linux build configuration source'
path name: :linux_config,          path: -> { packages.linux.build_path.join('.config') }, description: 'Linux build configuration target'
path name: :busybox_config_source, path: paths.src.join('busybox', 'config'),                description: 'Linux build configuration source'
path name: :busybox_config,        path: -> { packages.busybox.build_path.join('.config') }, description: 'Linux build configuration target'

path name: :builds,              path: paths.var.join('builds'),                         description: 'Package builds'
path name: :sources,             path: paths.var.join('sources'),                        description: 'Package sources'

path name: :task_graph,          path: paths.doc.join('task_graph.png'),                 description: 'Rake task dependency graph'

# Undescriptive paths
path name: :rakefile,   path: 'Rakefile'

path name: :build_root, path: paths.build.join('root') # TODO: Rename to just `root`
path name: :boot,       path: paths.build_root.join('boot')
path name: :initrd,     path: paths.build.join('initrd.cpio.gz')
path name: :kernel,     path: -> { packages.linux.build_path.join(*%w[arch x86 boot bzImage]) } # TODO: Use `uname -m`

path name: :task_paths, path: paths.tasks.join('**', '*.{rake,rb}')
path name: :fhs_paths,  path: paths.build_root.join(FHS_GLOB)
path name: :fs_paths,   path: paths.fs.join('**', '*')
path name: :fs_targets, path: paths.fs_paths.glob.sub(paths.fs, paths.build_root).join

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

desc 'See: os'
task default: 'os'

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

namespace :pkg do

  desc 'List all packages'
  task :list do
    packages.print
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
  task install: packages.install_paths

end

desc 'See: pkg:install'
task pkg: 'pkg:install'

namespace :path do

  desc 'List paths'
  task :list do
    paths.print
  end

  desc 'List all paths'
  task :all do
    paths.print(all: true)
  end

end

desc 'See: path:list'
task path: 'path:list'

namespace :os do

  desc 'Generate Linux FHS directories'
  task fhs: paths.fhs_paths.explode

  desc 'Synchronize filesystem'
  task fs: paths.fs_targets.split

  desc 'Generate initial ramdisk'
  task initrd: paths.initrd

end

desc 'See: os:initrd'
task os: 'os:initrd'

namespace :doc do

  desc "Generate dependency graph of rake tasks"
  task task_graph: paths.task_graph

end

desc 'See: doc:task_graph'
task doc: 'doc:task_graph'

# == Rules =========================================================================================

paths.task_paths.glob.each do |path|
  load(path)
end

