require 'set'
#for every 0-linkage
#  build the self-exclusive set of possible links
#  enqueue the single linkage score, the linkage, the free side, the self-exlusive subset
#
#  until the queue is empty:
#    shift from the queue
#    from that set find items that can link next and enqueue: the current score, the item, the free side, the self-exclusive subset
#
#total_set #input
total_set = Set.new(File.read("input.txt").scan(/(\d+)\/(\d+)/).map {|x| x.map(&:to_i) })
zero_links = total_set.select {|x| x.any?(&:zero?) }
queue = zero_links.map {|z|
  #length, Score, el, free el, self exclusive set
  [1,      z.sum,  z,   z.sum, total_set ^ Set[z]]
}
rotator = [1,0]
@max_score = 0
@longest_strongest = { length: 0, strength: 0 }

while !queue.empty? do
  #puts "#{queue.length}, #{@max_score}, #{@longest_strongest}"

  current_length,
  current_score,
  current_el,
  current_free,
  current_subset = queue.shift

  if current_score > @max_score
    @max_score = current_score
  end

  if current_length == @longest_strongest[:length]
    if current_score > @longest_strongest[:strength]
      @longest_strongest = {
        strength: current_score,
        length: current_length
      }
    end
  elsif current_length > @longest_strongest[:length]
    @longest_strongest = {
      strength: current_score,
      length: current_length
    }
  end

  current_subset.select {|el| el.any? {|e| e == current_free } }.each do |branch_el|
    queue << [
      current_length + 1,
      current_score + branch_el.sum,
      branch_el,
      branch_el[rotator[branch_el.index(current_free)]],
      current_subset ^ Set[branch_el]
    ]
  end
end

puts "PART 1: #{@max_score}"
puts "PART 2: #{@longest_strongest}"
