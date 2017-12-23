require 'prime'
a=b=c=d=e=f=g=h=0
a=1
b=65
c=b
b*=100
b+=100000
c=b+17000
h = loop do
  root_b = Math.sqrt(b)
  #hit = (2...(root_b.to_i + 1)).each do |d|     # divisors up to and including square root of b (plus one for good measure)
  #  hit = false                     #
  #  hit = ((root_b.to_i)...b).each do |e|       # divisors beneath or from square root of b up to b 
  #    break true if d * e == b      #           # increment h if any combination of the above multiply to reach b
  #  end                             # <- If any two numbers between 2 and b can be multiplied to reach b, increment h
  #                                  # <- SO if no two numbers between 2 and b can be multipled to reach b, b is prime
  #  break true if hit == true       # <- SO if b is not prime, increment h
  #end                               #
  if !Prime.prime?(b) # hit == true
    h += 1
  else
    puts "b: #{b}; h: remained the same"
  end
  break h if b == c
  b += 17
  puts "b: #{b}; h: #{h}"
end

puts "Part 2: #{h}"

# Input, change "sub -1" to "add 1" for legibility
# set b 65
# set c b
# jnz a 2
# jnz 1 5
# mul b 100
# add b 100000
# set c b
# add c 17000
# set f 1
# set d 2
# set e 2
# set g d
# mul g e
# sub g b
# jnz g 2 # to set f to 0, g must be 0. if g == b because d * e == b
# set f 0
# add e 1
# set g e
# sub g b
# jnz g -8 # why would g be 0... if g == b, and g was set by e... and e runs from 2...b
# add d 1
# set g d  
# sub g b
# jnz g -13 # why would g be 0... if g == b, and g was set by d
# jnz f 2   # why would f be 0... if we set it to zero by skipping an above command
# add h 1
# set g b
# sub g c
# jnz g 2   # why would g be 0... if g == c, and g was set by b
# jnz 1 3   # if b was finally c, finish
# add b 17  # if b was not yet c, increment b
# jnz 1 -23 # if b was not yet c, move back 23 steps
