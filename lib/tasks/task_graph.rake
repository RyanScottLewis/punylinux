require 'rgl/dot'
require 'rgl/implicit'

dependencies = []
dependencies << paths.rakefile
dependencies += paths.tasks.glob
dependencies << paths.doc

file paths.task_graph => dependencies do
  graph = RGL::ImplicitGraph.new

  graph.vertex_iterator do |iterator|
    Rake::Task.tasks.each { |task| iterator.call(task) }

    graph.adjacent_iterator { |t, b| t.prerequisites.each(&b) }
    graph.directed = true
  end

  graph.write_to_graphic_file('png', this_task.gsub(/\.png$/, ''))

  puts "Wrote dependency graph to '#{this_task}'."
end

