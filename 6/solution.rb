require "minitest/autorun"
require 'dbm'

class AOCTest < Minitest::Test
  def test_sample_input
    @input = "0 2 7 0"

    assert_equal 2, Solver.new(@input).send(:index_to_redistribute)
    assert_equal 5, Solver.new(@input).call[:redistribution_cycles].to_i # P1
    assert_equal 4, Solver.new(@input).call[:cycles].to_i                # P2
  end
end

class Solver
  def initialize(input)
    @input    = input.scan(/-?\d+/).map(&:to_i)
    @indexes  = 0.upto(@input.length - 1).to_a
    @progress = DBM.new('progress')
    log_progress
  end

  def call
    redistribute

    ret = {
      redistribution_cycles: @progress.size,                           # P1
      cycles:                @progress.size - @progress[state].to_i    # P2
    }

    FileUtils.rm_f("progress.db") and ret
  end

  private
  def redistribute
    loop do
      @indexes.rotate! index_to_redistribute

      redistribution_amount = @input[@indexes[0]]
      @input[@indexes[0]]   = 0

      while redistribution_amount > 0 do
        @indexes.rotate!

        @input[@indexes[0]]   += 1
        redistribution_amount -= 1
      end

      reset_indexes!

      log_progress or break
    end
  end

  def index_to_redistribute
    @input.index(@input.sort.reverse[0])
  end

  def reset_indexes!
    @indexes.sort!
  end

  def log_progress
    @progress[state] = @progress.size unless @progress.has_key?(state)
  end

  def state
    @input.join(" ")
  end
end

@input = File.read("input.txt")

puts Solver.new(@input).call
