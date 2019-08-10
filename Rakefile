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

path :build                                                            # Linux root, ISO image root, etc.
path :lib                                                              # Library sources (Ruby code for this Rakefile)
path :src                                                              # Project sources
path :tmp                                                              # Temporary file storage
path :var                                                              # Variable file storage
path :pkg                                                              # Package definitions

path :fs,                  paths.src.join('fs')                        # Files to import into the Linux root path
path :linux_config_source, paths.src.join('linux', 'config')           # Linux build configuration source
path(:linux_config)      { packages.linux.build_path.join('.config') } # Linux build configuration target

path :builds,              paths.var.join('builds')                    # Package builds
path :sources,             paths.var.join('sources')                   # Package sources

path :build_root, paths.build.join('root')                             # Linux root path - /
path :boot,       paths.build_root.join('boot')                        # Linux root path - boot/
path :initrd,     paths.boot.join('initrd.img')                        # Linux root path - boot/initrd.img # TODO: Use initrd.gz

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

require 'rgl/dot'
require 'rgl/implicit'

desc "Generate dependency graph of rake tasks"
task :dep_graph do |task|
  this_task = task.name

  dep = RGL::ImplicitGraph.new do |g|
    # vertices of the graph are all defined tasks without this task
    g.vertex_iterator do |b|
      Rake::Task.tasks.each do |t|
        b.call(t) unless t.name == this_task
      end
    end
    # neighbors of task t are its prerequisites
    g.adjacent_iterator { |t, b| t.prerequisites.each(&b) }
    g.directed = true
  end

  dep.write_to_graphic_file('png', this_task)
  puts "Wrote dependency graph to #{this_task}.png."
end

# == Rules =========================================================================================

# =- Directories -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

directory paths.sources.to_dir
directory paths.builds.to_dir
directory paths.tmp.to_dir
directory paths.build_root.to_dir
directory paths.boot.to_dir
directory paths.linux_config_source.dirname.to_dir

packages.each do |package|
  directory package.lock_path
end

# =- Files -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

paths.lib.join('tasks', '**', '*.{rake,rb}').glob.each do |path|
  load(path)
end


