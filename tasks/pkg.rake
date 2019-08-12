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

