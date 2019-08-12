$LOAD_PATH.unshift(File.expand_path(File.join("..", "lib"), __FILE__))
require 'bundler/setup'
require 'rake/clean'
require 'package/import'
require 'path/import'

# == Config ========================================================================================

NAME    = 'punylinux'
VERSION = '0.0.1'

# == Paths =========================================================================================

FHS      = %w(bin boot dev/pts dev/shm etc lib proc sbin sys tmp usr/bin usr/sbin)
FHS_GLOB = "{#{FHS.join(?,)}}"

# Descriptive paths
path name: :build,            description: 'Linux root, ISO image root, etc.'
path name: :doc,              description: 'Project documentation'
path name: :lib,              description: 'Library sources'
path name: :pkg,              description: 'Package definitions'
path name: :src,              description: 'Project sources'
path name: :tmp,              description: 'Temporary file storage'
path name: :var,              description: 'Variable file storage'
path name: :fs,               description: 'Files to import into the Linux root path'
path name: :tasks,            description: 'Rake tasks'

path name: :isolinux_image,   description: 'ISOLINUX image',             path: '/usr/lib/syslinux/bios/isolinux.bin'
path name: :isolinux_ldlinux, description: 'ISOLINUX ldlinux',           path: '/usr/lib/syslinux/bios/ldlinux.c32'
path name: :isolinux_config,  description: 'ISOLINUX configuration',     path: paths.src.join('isolinux', 'isolinux.cfg')

path name: :builds,           description: 'Package builds',             path: paths.var.join('builds')
path name: :sources,          description: 'Package sources',            path: paths.var.join('sources')

path name: :task_graph,       description: 'Rake task dependency graph', path: paths.doc.join('task_graph.png')

# Undescriptive paths
path name: :rakefile,             path: 'Rakefile'

path name: :linux_kernel,         path: -> { packages.linux.build_path.join(*%w[arch x86 boot bzImage]) } # TODO: Use `uname -m`

path name: :root,                 path: paths.build.join('root')

path name: :os_root,              path: paths.root.join('os')
path name: :os_boot,              path: paths.os_root.join('boot')
path name: :os_fhs,               path: paths.os_root.join(FHS_GLOB)
path name: :os_initrd,            path: paths.os_boot.join('initrd.cpio.gz')
path name: :os_kernel,            path: paths.os_boot.join('vmlinuz')

path name: :iso_root,             path: paths.root.join('iso')
path name: :iso_boot,             path: paths.iso_root.join('boot')
path name: :iso_initrd,           path: paths.iso_boot.join(NAME + '.' + paths.os_initrd.to_s.gsub(/^.+?\./, ''))
path name: :iso_kernel,           path: paths.iso_boot.join(NAME)
path name: :iso_isolinux,         path: paths.iso_root.join('isolinux')
path name: :iso_isolinux_image,   path: -> { paths.iso_isolinux.join(paths.isolinux_image.basename) }
path name: :iso_isolinux_ldlinux, path: -> { paths.iso_isolinux.join(paths.isolinux_ldlinux.basename) }
path name: :iso_isolinux_config,  path: paths.iso_isolinux.join(paths.isolinux_config.basename)
path name: :iso,                  path: paths.build.join("#{NAME}-#{VERSION}.iso")

path name: :task_paths,           path: paths.tasks.join('**', '*.{rake,rb}')
path name: :fs_paths,             path: paths.fs.join('**', '*')
path name: :fs_targets,           path: paths.fs_paths.glob.sub(paths.fs, paths.os_root).join

# == Packages ======================================================================================

# Load all package specifications
Package.load_all(paths)

# == Clean =========================================================================================

CLEAN.include paths.sources
CLEAN.include paths.tmp
CLEAN.include paths.task_graph

CLOBBER.include paths.build
CLOBBER.include paths.var

# == Tasks =========================================================================================

# Load all tasks under tasks/
paths.task_paths.glob.each { |path| load(path) }

# Default Rakefile task
desc 'See: iso'
task default: 'iso'

