require 'tsort'

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

graph = File.readlines('input.txt').map(&:rstrip!).map {|x| y = x.split(" <-> "); [y[0], y[1].split(", ")] }.to_h

puts "Part 1: #{graph.each_strongly_connected_component_from("0").size}"
puts "Part 2: #{graph.strongly_connected_components.length}"
