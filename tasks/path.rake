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

