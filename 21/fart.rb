require 'pry'
require 'benchmark'
class Fart
  attr_accessor :program
  def initialize(file)
    @rules = File.read(file).scan(/([.\/#]*) => ([.\/#]*)/).to_h
    @program = (<<-EOS).rstrip
.#.
..#
###
    EOS
  end

  def call
    split_program = program.split(/[\n\/]/)
    if split_program.size.even?
      subprogram_indices = 0.upto(split_program.size - 1).select(&:even?)
      subprograms = subprogram_indices.map {|j| subprogram_indices.map {|i| "#{split_program[j][(i)..(i+1)]}/#{split_program[j+1][(i)..(i+1)]}" } }.flatten
    else
      subprogram_indices = 0.upto(split_program.size - 1).to_a.select {|v| v % 3 == 0 }
      subprograms = subprogram_indices.map {|j| subprogram_indices.map {|i| "#{split_program[j][(i)..(i+2)]}/#{split_program[j+1][(i)..(i+2)]}/#{split_program[j+2][(i)..(i+2)]}" } }.flatten
    end

    expanded_program = subprograms.map {|p| transpose_program(p) }

    if expanded_program.size == 1
      @program = expanded_program[0]
    else
      root = Math.sqrt(expanded_program.join.gsub("/", "").size)

      factor = if expanded_program.size.even?
        3
      else
        case root % 2
        when 0
          4
        else
          3
        end
      end
      @program = expanded_program.map {|x| x.split("/") }.each_slice(root / factor).to_a.map(&:transpose).map {|grp| grp.map(&:join) }.map {|x| x.join("\n") }.join("\n")
    end
  end

  def rules_array
    @rules.keys.map {|x| x.split("/").map {|str| str.split(//)} }
  end

  def transpose_program(program)
    rulified = program.rstrip.gsub("\n", "/")

    @rules.fetch(rulified) {
      if double_rotated_rule = @rules.keys.detect {|x| x.split("/").reverse.map(&:reverse).join("/") == rulified }
        @rules[rulified] = @rules[double_rotated_rule]
      elsif rotated_and_flipped_rule = rules_array.map(&:transpose).map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[rotated_and_flipped_rule.reverse.transpose.map {|r| r.join }.join("/")]
      elsif flipped_and_rotated_rule = rules_array.map(&:reverse).map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[flipped_and_rotated_rule.transpose.reverse.map {|r| r.join }.join("/")]
      elsif flipped_rule = rules_array.map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[flipped_rule.reverse.map {|r| r.join }.join("/")]
      elsif magic_rule = @rules.keys.detect {|k| k.split("/").map(&:chars).transpose.map(&:join).join("/").reverse == program }
        @rules[rulified] = @rules[magic_rule]
      elsif rotated_rule = rules_array.map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[rotated_rule.transpose.map {|r| r.join }.join("/")]
      else
        raise rulified
      end
    }
  end
end

fart = Fart.new("input.txt")
puts "PART 2 (runtime): #{Benchmark.measure { 18.times { fart.call } }}"
puts "PART 2 (results): #{fart.program.chars.count {|c| c == "#"}}"

File.open('PART2.txt', 'w') { |file| file.write(fart.program) }
