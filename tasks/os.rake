namespace :os do

  desc 'Generate Linux FHS directories'
  task fhs: paths.os_fhs.explode

  desc 'Synchronize filesystem'
  task fs: paths.fs_targets.split

  desc 'Generate initial ramdisk'
  task initrd: paths.os_initrd

end

desc 'See: os:initrd'
task os: 'os:initrd'

