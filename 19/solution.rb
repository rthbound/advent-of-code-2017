require 'pry'
require "minitest/autorun"

class PipeworkTest < Minitest::Test
  def test_sample
    assert_equal "ABCDEF after 38 steps.", Pipework.new("test_input.txt").call
  end

  def test_production
    assert_equal "FEZDNIVJWT after 17200 steps.", Pipework.new("input.txt").call
  end
end

class Pipework
  attr_accessor :plumbing
  def initialize(file)
    @plumbing     = {}
    @step_counter = 0
    @passed       = []
    @vector       = Complex(0,1)
    File.readlines(file).each_with_index do |row,y|
      row.rstrip! # Ignore trailing whitespace and newlines
      row.each_char.with_index do |char,x|
        @plumbing[Complex(x,y)] = char
      end
    end

    @pipe = @plumbing.detect {|k,v| k.imag == 0 && v == "|"}[0]
  end

  def stops
    plumbing.values.join.scan /[A-Z]/
  end

  def increment_step_counter
    @step_counter += 1
  end

  def call
    ret = loop do
      begin
        increment_step_counter and process
      rescue EOFError
        break "#{@passed.join} after #{@step_counter} steps."
      end
    end
  end

  def process
    case plumbing[@pipe]
    when /[|-]/
      @pipe += @vector
    when /[A-Z]/
      @passed << plumbing[@pipe]
      raise EOFError if stops & @passed == stops
      @pipe += @vector
    when "+"
      if plumbing.fetch(@pipe + 1.i * @vector) {" "} != " "
        @vector *= 1.i
        @pipe += @vector
      elsif plumbing.fetch(@pipe + -1.i * @vector) {" "} != " "
        @vector *= -1.i
        @pipe += @vector
      else
        raise "TUBULAR"
      end
    else
      raise "TUBULAR"
    end
  end
end

puts "Sample: #{Pipework.new("test_input.txt").call}"
puts "P1-P2:  #{Pipework.new("input.txt").call}"
