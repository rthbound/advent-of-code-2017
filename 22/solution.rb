require 'pry'
class Sporifica
  attr_accessor :infection_counter
  def initialize(input)
    input = File.readlines(input).map(&:rstrip)

    @grid = {}
    input.each_with_index do |row, y|
      row.each_char.with_index do |char, x|
        @grid[Complex(x,y)] = char
      end
    end
    @original_grid = @grid.dup

    @position       = Complex(@grid.keys.max_by(&:real).real/2, @grid.keys.max_by(&:imag).imag/2)
    @current_vector = (0-1i)
    @infection_counter = 0
    puts_grid
  end

  def position_is_clean?
    node_status_at(@position) == "."
  end

  def puts_grid
    max_y = @grid.keys.max_by(&:imag).imag
    max_x = @grid.keys.max_by(&:real).real
    min_y = @grid.keys.min_by(&:imag).imag
    min_x = @grid.keys.min_by(&:real).real

    max = [max_y, max_x].max
    min = [min_y, min_x].min

    File.open("2017-day22-part1.txt", "w+") do |f|
      min.upto(max) do |y|
        f.puts min.upto(max).map { |x|
          node_status_at(Complex(x,y))
        }.join
      end
    end

    puts "======================="
  end

  def position_is_infected?
    node_status_at(@position) == "#"
  end

  def turn
    # Turn left if infected, otherwise turn right
    @current_vector *= position_is_infected? ? 1.i : -1.i
  end

  def node_status_at(coord)
    @grid[coord] = @grid.fetch(coord) { "." }
  end

  def move
    prepare_to_move and advance_position
  end

  def advance_position
    node_status_at(@position + @current_vector)
    @position += @current_vector
  end

  def prepare_to_move
    turn and clean_or_infect
  end

  def originally_infected
    @original_grid.select {|_,v| v == "#" }.keys
  end

  def clean_or_infect
    # If node is cleaned, we will infect and increase counter
    @infection_counter += 1 if node_status_at(@position) == "." && !originally_infected.include?(@position)
    @grid[@position].gsub!(/[#]?[.]?/, "." => "#", "#" => ".")
  end
end

virus = Sporifica.new("test_input.txt")

10000.times { virus.move }
virus.puts_grid

puts virus.infection_counter

virus = Sporifica.new("input.txt")

10000.times { virus.move }
virus.puts_grid

puts virus.infection_counter
