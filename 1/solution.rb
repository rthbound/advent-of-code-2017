require 'pry'
samples = {
  "1122"     => 3,
  "1111"     => 4,
  "1234"     => 0,
  "91212129" => 9,
  File.read("input.txt").rstrip! => nil
}

samples.each do |k,v|
  effective_chars = k.split(//) << k[0]

  puts k
  puts effective_chars.join

  result = effective_chars.each_cons(2).map { |pair| pair.uniq.length == 1 ? pair[0].to_i : 0 }.inject(0, :+)

  samples[k] = result
end

puts samples

samples = {
  "1212"     => 6,
  "1221"     => 0,
  "123425"   => 4,
  "123123"   => 12,
  "12131415" => 4,
  File.read("input.txt").rstrip! => nil
}

samples.each do |k,v|
  rotation = k.length / 2
  effective_chars = k.split(//)

  result = effective_chars.map.with_index {|el,i| el == effective_chars.rotate(rotation + i).first ? el.to_i : 0 }.inject(0, :+)

  samples[k] = result
end

puts samples
