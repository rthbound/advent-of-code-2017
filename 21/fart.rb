require 'pry'
class Fart
  attr_accessor :program
  def initialize(file)
    @rules = File.read(file).scan(/([.\/#]*) => ([.\/#]*)/).to_h
    @source = File.read(file)
    @program = (<<-EOS).rstrip
.#.
..#
###
    EOS
  end

  def call(i)
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
      if expanded_program.size.even?
        magic_number = Math.sqrt(expanded_program.join.gsub("/", "").size)
        @program = expanded_program.map {|x| x.split("/") }.each_slice(magic_number / 3).to_a.map {|x| x.transpose }.map {|half| half.map(&:join) }.map {|x| x.join("\n") }.join("\n")
      else
        case Math.sqrt(expanded_program.join.gsub("/", "").size)
        when 9
          @program = expanded_program.map {|x| x.split("/") }.each_slice(9/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 12
          @program = expanded_program.map {|x| x.split("/") }.each_slice(12/4).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 18
          @program = expanded_program.map {|x| x.split("/") }.each_slice(18/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 27
          @program = expanded_program.map {|x| x.split("/") }.each_slice(27/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 36
          @program = expanded_program.map {|x| x.split("/") }.each_slice(36/4).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 81
          @program = expanded_program.map {|x| x.split("/") }.each_slice(81/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 108
          @program = expanded_program.map {|x| x.split("/") }.each_slice(108/4).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 243
          @program = expanded_program.map {|x| x.split("/") }.each_slice(243/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 324
          @program = expanded_program.map {|x| x.split("/") }.each_slice(324/4).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 729
          @program = expanded_program.map {|x| x.split("/") }.each_slice(729/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 972
          @program = expanded_program.map {|x| x.split("/") }.each_slice(972/4).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        when 2187
          @program = expanded_program.map {|x| x.split("/") }.each_slice(2187/3).to_a.map(&:transpose).map {|third| third.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        else
          binding.pry
          magic_number = expanded_program[0].split("/")[0].size
          @program = expanded_program.map {|x| x.split("/") }.each_slice(magic_number).to_a.map {|x| x.transpose }.map {|half| half.map(&:join) }.map {|x| x.join("\n") }.join("\n")
        end
      end
    end

    #0.upto(split.length - 1).select(&:even?)
  end

  def rules_array
    @rules.keys.map {|x| x.split("/").map {|str| str.split(//)} }
  end
  def transpose_program(program)
    size = program.split(/[\n\/]/).size
    rets = case size
    when 3
      rulified = program.rstrip.gsub("\n", "/")
      #if @rules[rulified]
      #  @rules[rulified]
      #elsif rotated_rule = rules_array.map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
      #  @rules[rotated_rule.transpose.map {|r| r.join }.join("/")]
      #elsif flipped_rule = rules_array.map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
      #  @rules[flipped_rule.reverse.map {|r| r.join }.join("/")]
      #end
        res = if @rules[rulified]
          @rules[rulified]
        elsif rotated_rule = rules_array.map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
          @rules[rulified] = @rules[rotated_rule.transpose.map {|r| r.join }.join("/")]
        elsif flipped_rule = rules_array.map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
          @rules[rulified] = @rules[flipped_rule.reverse.map {|r| r.join }.join("/")]
        elsif flipped_and_rotated_rule = rules_array.map(&:reverse).map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
          @rules[rulified] = @rules[flipped_and_rotated_rule.transpose.reverse.map {|r| r.join }.join("/")]
        elsif rotated_and_flipped_rule = rules_array.map(&:transpose).map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
          @rules[rulified] = @rules[rotated_and_flipped_rule.reverse.transpose.map {|r| r.join }.join("/")]
        elsif double_rotated_rule = @rules.keys.detect {|x| x.split("/").reverse.map(&:reverse).join("/") == rulified }
          @rules[rulified] = @rules[double_rotated_rule]
        elsif magic_rule = @rules.keys.detect {|x| (x.split("/").map(&:reverse) & program.split("/")).length == 3 }
          @rules[rulified] = @rules[magic_rule]
        else
          binding.pry
        end
    when 2
      rulified = program.rstrip.gsub("\n", "/")
      if @rules[rulified]
        @rules[rulified]
      elsif rotated_rule = rules_array.map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[rotated_rule.transpose.map {|r| r.join }.join("/")]
      elsif flipped_rule = rules_array.map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[flipped_rule.reverse.map {|r| r.join }.join("/")]
      elsif flipped_and_rotated_rule = rules_array.map(&:reverse).map(&:transpose).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[flipped_and_rotated_rule.transpose.reverse.map {|r| r.join }.join("/")]
      elsif magic_rule = @rules.keys.detect {|x| (x.split("/").map(&:reverse) & program.split("/")).length == 3 }
        @rules[rulified] = @rules[magic_rule]
      elsif rotated_and_flipped_rule = rules_array.map(&:transpose).map(&:reverse).detect {|r| r.map {|x| x.join }.join("/") == rulified }
        @rules[rulified] = @rules[rotated_and_flipped_rule.reverse.transpose.map {|r| r.join }.join("/")]
      elsif double_rotated_rule = @rules.keys.detect {|x| x.split("/").reverse.map(&:reverse).join("/") == rulified }
        @rules[rulified] = @rules[double_rotated_rule]
      else
        binding.pry
      end
    else
      binding.pry
    end

    rets
  end
end

#fart = Fart.new("input.txt")

#5.times { |i|
#  fart.call(i)
#}
#File.open('PART1.txt', 'w') { |file| file.write(fart.program) }
#puts fart.program.chars.count {|c| c == "#"}
#
fart = Fart.new("input.txt")

18.times { |i|
  fart.call(i)
}
File.open('PART2.txt', 'w') { |file| file.write(fart.program) }
puts fart.program.chars.count {|c| c == "#"}
