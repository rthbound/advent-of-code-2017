require 'matrix'
class Hecks
  def initialize(instructions)
    @instructions = instructions.scan /\w+/

    # Hecks grid:           x,y,z
    @position     = Matrix[[0,0,0]]
    @map = {
      "n"  => Matrix[[0,1,-1]],
      "ne" => Matrix[[1,0,-1]],
      "nw" => Matrix[[-1,1,0]],
      "s"  => Matrix[[0,-1,1]],
      "se" => Matrix[[1,-1,0]],
      "sw" => Matrix[[-1,0,1]],
    }
    @max_distance = 0
  end

  def call
    traverse and { distance: return_distance, max_distance: @max_distance }
  end

  private
  def traverse
    @instructions.each { |vector|
      @position += @map[vector] and update_max_distance(return_distance)
    }
  end

  def return_distance
    0.5 * (
      (0 - @position[0,0]).abs +
      (0 - @position[0,1]).abs +
      (0 - @position[0,2]).abs
    )
  end

  def update_max_distance(dist)
    @max_distance = [@max_distance, dist].max
  end
end

input = File.read("input.txt")
puts Hecks.new(input).call
