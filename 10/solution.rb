require 'pry'
require 'benchmark'
#require "minitest/autorun"
#
#class AOCTest < Minitest::Test
#  def test_hello_world
#    assert Solver.new("test_input.txt", 5).list == [0, 1, 2, 3, 4]
#  end
#
#  def test_solves_sample_from_part_one
#    p1 = Solver.new(
#      File.read("test_input.txt").scan(/\d+/).map(&:to_i),
#      5,
#      1
#    )
#
#    p1.call and assert_equal 12, p1.list.first(2).inject(:*)
#  end
#end

class Solver
  attr_accessor :input, :list, :n
  def initialize(input, length = 256, n = 1)
    @input  = input
    @length = length
    @n      = n
    @list   = Array.new(length) {|i| i }
  end

  def call
    position  = 0
    skip_size = 0

    res = n.times do
      @input.each do |width|
        list.rotate!(position)
        list[0,width] = list[0,width].reverse
        list.rotate!(-position)
        position  += width + skip_size
        skip_size += 1
      end
    end
  end
end

# Part 1
#p1 = Solver.new(
#  File.read("input.txt").scan(/\d+/).map(&:to_i),
#  256,
#  1
#)
#puts Benchmark.measure {
#  p1.call and puts "P1: #{p1.list.first(2).inject(:*)}"
#}
#
## Part 2
#p2 = Solver.new(
#  File.read("input.txt").rstrip.codepoints + [17, 31, 73, 47, 23],
#  256,
#  64
#)
#puts Benchmark.measure {
#  p2.call and puts "P2: #{p2.list.each_slice(16).map {|x| x.inject(0,:^).to_s(16).rjust(2,"0") }.join}"
#}
