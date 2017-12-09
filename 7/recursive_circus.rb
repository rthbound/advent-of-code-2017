require 'tsort'
require "minitest/autorun"

class LionTamerTest < Minitest::Test
  def test_finds_worst_lion
    @input = RecursiveCircus.new("sample_input.txt")
    @subject = LionTamer.new(@input).call

    assert_equal "ugml", @subject[:lion_name]
    assert_equal 60,     @subject[:desired_lion_score]
  end
end

class RecursiveCircusTest < Minitest::Test
  def test_finds_root_program_for_sample_input
    @input = "sample_input.txt"

    assert_equal "tknk", RecursiveCircus.new(@input).root_program
  end

  def test_finds_programs_by_name
    @input = "sample_input.txt"

    assert_equal "tknk (41) -> ugml, padx, fwft", RecursiveCircus.new(@input).send(:find, "tknk")
  end

  def test_finds_program_weight
    @input = "sample_input.txt"

    assert_equal 41, RecursiveCircus.new(@input).send(:program_weight, "tknk")
  end

  def test_finds_total_weight_of_program
    @input = "sample_input.txt"

    assert_equal 251, RecursiveCircus.new(@input).send(:total_weight, "ugml")
  end

  def test_finds_total_weight_of_program_at_top
    @input = "sample_input.txt"

    assert_equal 66, RecursiveCircus.new(@input).send(:total_weight, "pbga")
  end

  def test_finds_individual_subprogram_weights
    @input = "sample_input.txt"

    assert_equal [61, 61, 61], RecursiveCircus.new(@input).send(:sub_program_weights, "ugml")
  end
end

class Hash
  include TSort
  alias tsort_each_node each_key
  def tsort_each_child(node, &block)
    fetch(node).each(&block)
  end
end

class LionTamer
  attr_reader :circus

  def initialize(circus)
    @circus = circus
  end

  def call
    bad_lion = find_worst_lion(circus.root_program)
  end

  def find_worst_lion(momma_lion, momma_lions_momma = nil)
    baby_lions = circus.sub_program_weights(momma_lion)

    if bad_lion = baby_lions.detect {|w| baby_lions.count(w) == 1 }
      bad_baby_lion = baby_lions.index(bad_lion)

      find_worst_lion(circus.tower_of_programs[momma_lion][bad_baby_lion], momma_lion)
    else
      {
        lion_name: momma_lion,
        desired_lion_score: circus.program_weight(momma_lion) + circus.sub_program_weights(momma_lions_momma).sort.uniq.inject(:-)
      }
    end
  end
end

class RecursiveCircus
  attr_reader :program_list, :tower_of_programs
  def initialize(input)
    @program_list      = File.readlines(input).map(&:rstrip)
    @tower_of_programs = @program_list.map { |p| p.scan(/(\w+)/).flatten }.map { |p| [p.first, p.slice(2..-1)] }.to_h
  end

  def root_program
    @tower_of_programs.strongly_connected_components.flatten.last
  end

  def find(program_name)
    @program_list.detect { |p| p.start_with? program_name }
  end

  def program_weight(program_name)
    program = find(program_name)
    weight(program)
  end

  def sub_program_weights(program_name)
    @tower_of_programs[program_name].map { |p| total_weight(p) }
  end

  def total_weight(program_name)
    @tower_of_programs.each_strongly_connected_component_from(program_name).to_a.flatten.map { |p| program_weight(p) }.inject(0, :+)
  end

  def weight(program)
    program.scan(/\d+/)[0].to_i
  end
end

circus = RecursiveCircus.new("input.txt")
puts "Part 1: #{circus.root_program}"
puts "Part 2: #{LionTamer.new(circus).call}"
