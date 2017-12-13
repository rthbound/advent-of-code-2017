require 'pry'

firewall = File.read("input.txt").scan(/(\d+): (\d+)/).map {|x| [x[0].to_i, 1.upto(x[1].to_i).to_a] }.to_h
delay = 1

loop do
  break(delay) if firewall.none? {|depth,range| (delay + depth) % ((range.size - 1) * 2) == 0 }
  delay += 1
end

puts "P2: #{delay}"
