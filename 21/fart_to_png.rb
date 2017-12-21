require 'oily_png'

class FartToPng
  def initialize width = 2187
		@width = width
		@height = width

    @grid = File.readlines("PART2.txt").map(&:rstrip)
    @grid = @grid.map(&:chars)
  end

  def step
  end

  def draw
    img = ChunkyPNG::Image.new(@width, @height, ChunkyPNG::Color::TRANSPARENT)

    @grid.each.with_index {|row,y|
      row.each.with_index {|char,x|
        img[x,y] = char == "." ? 0 : 255
      }
    }

    img.save('2017-d21-p2.png', :interlace => true)
  end
end

FartToPng.new.draw
