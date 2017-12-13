require 'pry'

firewall = File.read("input.txt").scan(/(\d+): (\d+)/).map {|x| [x[0].to_i, 1.upto(x[1].to_i).to_a] }.to_h
severity = 0
scanner_directions = firewall.keys.map {|k| [k,1] }.to_h


(firewall.keys.min).upto(firewall.keys.max) do |position|
  severity += firewall.fetch(position) { [] }[0] == 1 ? position * firewall[position].max : 0

  firewall.each do |k,v|
      if firewall[k][-1] == 1
        scanner_directions[k] *= -1
      elsif firewall[k][0] == 1
        scanner_directions[k] *= -1
      end

    firewall[k] = firewall[k].rotate!(scanner_directions[k])
  end
end

puts "P1: #{severity}"
