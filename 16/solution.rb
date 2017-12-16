require 'benchmark'
require 'pry'
inp = File.read('input.txt').rstrip!
cmds = inp.split(",")
@given = "a".upto("p").to_a

def dance(str)
  case str
  when /x\w+\/\w+/
    at, from = str.scan(/\d+/).map(&:to_i)
    @given[at], @given[from] = @given[from], @given[at]
  when /p\w+\/\w+/
    str1, str2 = str[1..-1].scan(/\w+/)
    i1 , i2 = @given.index(str1), @given.index(str2)
    @given[i1] = str2
    @given[i2] = str1
  when /s\w+/
    sep = str[/\d+/].to_i
    @given.rotate!(-sep)
  end
end

known    = []
n        = 1_000_000_000
first    = nil

puts Benchmark.measure {
  n.times { |i|
    known.include?(@given.join) and break or known << @given.join

    cmds.each {|str| dance str }
    first ||= @given.join #P1
  }

  puts "P1: #{first}"
  puts "P2: #{known[n % known.length]}"
}
