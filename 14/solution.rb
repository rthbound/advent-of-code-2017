require "pry"
require 'tsort'
require_relative '../10/solution'

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class Solution
  def initialize(input)
    @width  = 256
    @height = 127
    @input  = input
    @grid    = {}
    @regions = {}
  end

  def call
    r = 0.upto(@height).map do |h|
      knot_hash = Solver.new("#{@input}-#{h}".codepoints + [17, 31, 73, 47, 23], 256, 64)
      knot_hash.call
      knot_hash_dense_hash = knot_hash.list.each_slice(16).map { |x| x.inject(0,:^).to_s(16).rjust(2,"0") }.join

      g = knot_hash_dense_hash.each_char.map {|c| c.to_i(16).to_s(2).rjust(4, "0") }.join.gsub("1", "#").gsub("0", ".")

      # Build grid and prepare regions
      g.each_char.with_index do |c,w|
        @grid[Complex(w,h)]    = c
        @regions[Complex(w,h)] = [Complex(w,h)] if c == "#"
      end
    end

    r.each.with_index do |row,h|
      row.each_char.with_index do |c,w|
        if c == "#"
          @regions[Complex(w,h)] = [Complex(w,h)]
          [
            Complex(w+1, h),
            Complex(w-1, h),
            Complex(w, h+1),
            Complex(w, h-1)
          ].each do |adj|
            @regions[Complex(w,h)] << adj if @grid[adj] == "#"
          end
        end
      end
    end

    puts "P1: #{r.join.count("#")}"
    @regions.reject! {|k,v| v.empty? }
    puts "P2: #{@regions.strongly_connected_components.count}"

  end
end

puts "Staging"
puts Solution.new("flqrgnkx").call

puts "Production"
puts Solution.new("oundnydw").call
