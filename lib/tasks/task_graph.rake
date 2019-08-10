require 'rgl/dot'
require 'rgl/implicit'

dependencies = []
dependencies << paths.rakefile
dependencies += paths.task_pattern.glob
dependencies << paths.doc.to_dir

file paths.task_graph => dependencies do |task|
  this_task = task.name

  graph = RGL::ImplicitGraph.new# do |graph|

  graph.vertex_iterator do |b|
    Rake::Task.tasks.each do |t|
      b.call(t)
    end

    graph.adjacent_iterator { |t, b| t.prerequisites.each(&b) }
    graph.directed = true
  end

  graph.write_to_graphic_file('png', this_task.gsub(/\.png$/, ''))

  puts "Wrote dependency graph to '#{this_task}'."
end

