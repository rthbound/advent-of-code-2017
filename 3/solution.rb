# Observations:G
# 1) The bottom right element of the square will be an odd perfect square (1, 9, 25)
# 2) The side lengths will be equal to the sqr root of that odd perfect square.
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
      number:          @number,
      bottom_right:    bottom_right,
      bottom_left:     bottom_left,
      top_left:        top_left,
      top_right:       top_right,
      corners:         corners,
      number_location: number_location
    }
  end


  def bottom_right # Coordinate of bottom right corner
    corner_square = first_odd_perfect_square_containing

    @bottom_right ||= Complex(                           # 5 4 3  # Since root of 9 is 3, and 3/2 returns 1
       (corner_square / 2), # x, or real component       # 6 1 2  # We expect our 9 is located at 1,-1
      -(corner_square / 2)  # y, or imaginary component  # 7 8 9  # Assuming that 1 is origin (at 0,0)
    )
  end


  def bottom_left  # Coordinate of bottom left corner
    # The bottom left corner will be due left of the bottom right corner,
    # so we need to decrease its real component by one less than the side length
    @bottom_left ||= bottom_right - (first_odd_perfect_square_containing - 1)
  end


  def top_left     # Coordinate of top left corner
    # The top left corner will be due up from the bottom left corner,
    # so we need to increase its imag component by one less than the side length
    @top_left ||= bottom_left + Complex(0,first_odd_perfect_square_containing - 1)
  end


  def top_right    # Coordinate of top right corner
    # The top right corner will be due right of the top left corner,
    # so we need to increase its real component by one less than the side length
    @top_right ||= top_left + (first_odd_perfect_square_containing - 1)
  end

  def corners
    # The value in the bottom right corner
    max = first_odd_perfect_square_containing ** 2

    # The value and location of each corner
    # value => location
    @corners ||= {
      max                                                 => bottom_right,
      max - 1 * (first_odd_perfect_square_containing - 1) => bottom_left,
      max - 2 * (first_odd_perfect_square_containing - 1) => top_left,
      max - 3 * (first_odd_perfect_square_containing - 1) => top_right,
    }
  end

  def number_location
    # Returns:
    # value => location
    case (@corners.keys << @number).sort.index(@number) + 1
    when 4
      #    # # #
      #    # # #
      #    # . #
      { @number => @corners[@corners.keys.sort[3]] - Complex((@corners.keys.sort[3] - @number), 0) }
    when 3
      #    # # #
      #    . # #
      #    # # #
      { @number => @corners[@corners.keys.sort[2]] + Complex(0, (@corners.keys.sort[2] - @number)) }
    when 2
      #    # . #
      #    # # #
      #    # # #
      { @number => @corners[@corners.keys.sort[1]] + Complex((@corners.keys.sort[1] - @number), 0) }
    when 1
      #    # # #
      #    # # .
      #    # # #
      { @number => @corners[@corners.keys.sort[0]] - Complex(0, (@corners.keys.sort[0] - @number)) }
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
