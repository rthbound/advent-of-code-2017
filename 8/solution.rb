require 'pry'
require "minitest/autorun"
require 'dbm'

class Dispatcher
  def initialize(instruction, registers)
    @instruction = instruction
    @registers   = registers
  end

  def call
    dispatch_instruction(*@instruction.flatten)
  end

  def dispatch_instruction(register, direction, delta, compare_register, condition, value)
    @registers[register] = value_at(register) + delta.to_i * sign(direction) if value_at(compare_register).send(condition, value.to_i)
  end

  def value_at(register)
    @registers.fetch(register) { 0 }.to_i
  end

  def sign(direction)
    case direction
    when "inc"
      1
    when "dec"
      -1
    else
      raise "unknown direction"
    end
  end
end

class Processor
  def initialize(input)
    @instructions = File.read(input).scan(/(\w+) (inc|dec) (-?\d+) if (\w+) ([!=<>]+) (-?\d+)/)
    @registers = DBM.new('register')
    @absolute_max = -Float::INFINITY
  end

  def call
    @instructions.each do |i|
      Dispatcher.new(i, @registers).call
      @absolute_max = current_max if current_max > @absolute_max
    end

    ret_val = @registers.to_hash.merge!({
      absolute_max: @absolute_max,
      current_max:  current_max
    })

    FileUtils.rm_f("register.db") and return ret_val
  end

  def current_max
    @registers.values.map(&:to_i).max || @absolute_max
  end
end

res = Processor.new("input.txt").call
puts res[:current_max]
puts res[:absolute_max]
