class SpiralMemory
  def initialize(number)
    @number = number.to_i
  end

  def call
    return_object
  end

  private
  def first_odd_perfect_square_containing
    return @first_odd_perfect_square_containing unless @first_odd_perfect_square_containing.nil?
    @first_odd_perfect_square_containing = Math.sqrt(@number).ceil
    @first_odd_perfect_square_containing += 1 unless @first_odd_perfect_square_containing.odd?
    @first_odd_perfect_square_containing
  end

  def return_object
    {
      number: @number,
      bottom_right: bottom_right,
      bottom_left: bottom_left,
      top_left: top_left,
      top_right: top_right,
      corners: corners,
      number_location: number_location
    }
  end

  def bottom_right
    corner_square = first_odd_perfect_square_containing

    @bottom_right ||= Complex(
      (corner_square / 2),
      -(corner_square / 2)
    )
  end

  def bottom_left
    @bottom_left ||= bottom_right - (first_odd_perfect_square_containing - 1)
  end

  def top_left
    @top_left ||= bottom_left + Complex(0,first_odd_perfect_square_containing - 1)
  end

  def top_right
    @top_right ||= top_left + (first_odd_perfect_square_containing - 1)
  end

  def corners
    max = first_odd_perfect_square_containing ** 2

    @corners ||= {
      max                                                 => bottom_right,
      max - 1 * (first_odd_perfect_square_containing - 1) => bottom_left,
      max - 2 * (first_odd_perfect_square_containing - 1) => top_left,
      max - 3 * (first_odd_perfect_square_containing - 1) => top_right,
    }
  end

  def number_location
    case (@corners.keys << @number).sort.index(@number) + 1
    when 4
      { @number => @corners[@corners.keys.sort[3]] - (@corners.keys.sort[3] - @number) }
    when 3
      { @number => @corners[@corners.keys.sort[2]] + Complex(0,(@corners.keys.sort[2] - @number)) }
    when 2
      { @number => @corners[@corners.keys.sort[1]] + (@corners.keys.sort[1] - @number) }
    when 1
      { @number => @corners[@corners.keys.sort[0]] - Complex(0,(@corners.keys.sort[0] - @number)) }
    end
  end
end

#res = SpiralMemory.new(1).call[:number_location]
#res = SpiralMemory.new(12).call[:number_location]
#res = SpiralMemory.new(23).call[:number_location]
#res = SpiralMemory.new(1024).call[:number_location]
res = SpiralMemory.new(ARGV[0]).call[:number_location]

v = res.values.first
ret_v = v.real.abs + v.imag.abs

puts ret_v
