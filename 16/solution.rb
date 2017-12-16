require 'benchmark'
require 'pry'
inp = File.read('input.txt').rstrip!

cmds = inp.split(",")
#cmds = ["s1", "x3/4", "pe/b"]

h = {}

#Spin, written sX, makes X programs move from the end to the front, but maintain their order otherwise. 
#  (For example, s3 on abcde produces cdeab).

#Exchange, written xA/B, makes the programs at positions A and B swap places.
#Partner, written pA/B, makes the programs named A and B swap places.

#@given = "abcde".split(//)
@given = "a".upto("p").to_a

def dispatch(str)
  case str
  when /x\w+\/\w+/
    at, from = str.scan(/\d+/).map(&:to_i)
    str1, str2 = @given[at], @given[from]
    @given[at] = str2
    @given[from] = str1
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


remaining = 1_000_000_000
first = nil
puts Benchmark.measure {
  remaining.times { |i|i                    # assume we need to run all 10 billion times
    break if i >= remaining                   # but break early if the goalposts come to us
    if h.has_key? @given.join                 # if we have seen this state before
      prev_i, value = h[@given.join]             # when did we last see this state
      interval = i - prev_i                      # what's the interval interval between repeated states
      current_remaining = remaining - i - 1      # how many iterations currently remain to be processed, i is 0 indexed
      if current_remaining >= interval           # if the current interval wont overflow remaining iterations available
        skip_times = current_remaining / interval  # how many times does the repeat interval fit evenly into what remains
        remaining -= skip_times * interval         # skip the interval that many times
      end
    end

    # Whether we are able to fastforward (above) or not, we still need to check the next state(s)
    # in case they become familiar
    before = @given.join        # store state before dancing
    cmds.each {|x| dispatch x } # dance
    h[before] = [i,@given]      # cache iteration index and after-state for before-state
    first ||= @given.join
  }

  puts "P1: #{first}"
  puts "P2: #{@given.join}"
}
