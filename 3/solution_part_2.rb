class SpiralFantasy
  def initialize(number)
    @number = number.to_i
    @grid = { Complex(0,0) => 1 }
  end

  def call
    draw.values.max
  end

  private

  def draw
    start = Complex(0,0)
    directions = [ :right, :up, :left, :down ]
    while(@grid.values.max <= @number) do
      case directions[0]
      when :right
        start += Complex(1,0)
        @grid.merge!({ start => next_cell(start) })
        directions.rotate! if start.real == -(start.imag - 1)
      when :up
        start += Complex(0,1)
        @grid.merge!({ start => next_cell(start) })
        directions.rotate! if start.real.abs == start.imag.abs
      when :left
        start += Complex(-1,0)
        @grid.merge!({ start => next_cell(start) })
        directions.rotate! if start.real.abs == start.imag.abs
      when :down
        start += Complex(0,-1)
        @grid.merge!({ start => next_cell(start) })
        directions.rotate! if start.real.abs == start.imag.abs
      end
    end

    @grid
  end

  def next_cell(current)
    keys = [
      current + Complex(-1, 0),
      current + Complex( 1, 0),
      current + Complex( 1, 1),
      current + Complex(-1,-1),
      current + Complex(-1, 1),
      current + Complex( 1,-1),
      current + Complex( 0, 1),
      current + Complex( 0,-1),
    ]

    @grid.values_at(*keys).compact.inject(:+)
  end
end

puts SpiralFantasy.new(ARGV[0]).call
