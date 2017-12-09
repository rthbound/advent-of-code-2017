require 'pry'
require "minitest/autorun"

class AOCTest < Minitest::Test
  def test_filters_out_groups_in_garbage
    @input = "{<{}>}{}"
    assert_equal "{}{}", GarbageFilter.new(@input).call
  end

  def test_ignores_garbage_ending_when_instructed
    @input = "{<{}>}{}{<!>}{}>}{{}}"
    assert_equal "{}{}{}{{}}", GarbageFilter.new(@input).call
  end

  def test_filters_many_pieces_of_garbage
    assert [
      "<random characters>",
      "<>",
      "<<<<>",
      "<{!>}>",
      "<!!>",
      "<!!!>>",
      "<{o\"i!a,<{i< a>",
    ].all? { |input| GarbageFilter.new(input).call.empty? }
  end

  def test_keeps_commas
    @input = "{<a>,<a>,<a>,<a>}"
    assert_equal "{,,,}", GarbageFilter.new(@input).call
  end

  def test_ignores_really_good
    @input = "{{<!>},{<!>},{<!>},{<a>}}"
    assert_equal "{{}}", GarbageFilter.new(@input).call
  end

  ###
  def test_scoring_one
    @input = "{}"
    assert_equal 1, Compost.new(@input).call
  end

  def test_scoring_six
    @input = "{{{}}}"
    assert_equal 6, Compost.new(@input).call
  end

  def test_scoring_sixteen
    @input = "{{{},{},{{}}}}"
    assert_equal 16, Compost.new(@input).call
  end

  def test_scoring_three_in_spite_of_garbage
    @input = "{{<a!>},{<a!>},{<a!>},{<ab>}}"
    assert_equal 3, Compost.new(@input).call
  end

  def test_scoring_nine_in_spite_of_garbage
    @input = "{{<!!>},{<!!>},{<!!>},{<!!>}}"
    assert_equal 9, Compost.new(@input).call
  end
end

class Compost
  def initialize(input)
    @input = GarbageFilter.new(input).call
    @input = @input.chars
    @points_scored = []
  end

  def call
    current_score = 0
    @input.each do |char|
      case char
      when "{"
        current_score += 1
      when "}"
        @points_scored << current_score
        current_score -= 1
      end
    end

    @points_scored.sum
  end
end

class GarbageFilter
  attr_accessor :garbage_counter
  def initialize(input)
    @input        = input.chars
    @output       = ""
    @garbage_mode = false
    @ignore_mode  = false
    @garbage_counter = 0
  end

  def call
    @input.each do |char|
      if @ignore_mode
        @ignore_mode = false
      else
        case @garbage_mode
        when false
          case char
          when "<"
            @garbage_mode = true
          else
            @output << char
          end
        when true
          case char
          when ">"
            @garbage_mode = false
          when "!"
            @ignore_mode = true
          else
            @garbage_counter += 1
          end
        end
      end
    end

    return @output
  end
end

puts "Part 1: #{Compost.new(File.read("input.txt")).call}"

p2 = GarbageFilter.new(File.read("input.txt"))
p2.call

puts "Part 2: #{p2.garbage_counter}"
