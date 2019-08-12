namespace :doc do

  desc "Generate dependency graph of rake tasks"
  task task_graph: paths.task_graph

end

desc 'See: doc:task_graph'
task doc: 'doc:task_graph'

