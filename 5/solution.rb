require "minitest/autorun"

class AOCTest < Minitest::Test
  def test_returns_one_if_first_instruction_jumps_out
    @input = "4 0  1  -3"
    assert_equal 1, Solver.new(@input).call
  end

  def test_jumps_until_right_answer_is_found
    @input = "0 3  0  1  -3"
    assert_equal 5, Solver.new(@input).call
  end
end

class Solver
  def initialize(input)
    @position     = 0
    @input        = input.scan(/-?\d+/).map(&:to_i)
    @jump_counter = 1
  end

  def call
    until jumps_out? do
      jump and @jump_counter += 1
    end

    return @jump_counter
  end

  private
  def instruction
    @input[@position]
  end

  def jumps_out?
    !(0..(@input.size - 1)).include?(@position + instruction)
  end

  def jump
    old_position          = @position
    @position            += instruction
    @input[old_position] += 1
  end
end

@input = File.read("input.txt")
puts "Are you readyyyyy?!"
3.downto(1) {|i| sleep 0.5; puts i }
puts Solver.new(@input).call
