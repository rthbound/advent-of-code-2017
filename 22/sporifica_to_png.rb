require 'oily_png'

class SporificaToPng
  def initialize width = 414
		@width  = width
		@height = width

    @grid = File.readlines("2017-day22-part2.txt").map(&:rstrip)
    @grid = @grid.map(&:chars)
  end

  def step
  end

  def draw
    img = ChunkyPNG::Image.new(@width, @height, ChunkyPNG::Color::TRANSPARENT)

    @grid.each.with_index {|row,y|
      row.each.with_index {|char,x|
        img[x,y] = case char
        when "."
          :aliceblue
        when "W"
          :darksalmon
        when "#"
          :maroon
        when "F"
          :lightsalmon
        end
      }
    }

    img.save('2017-day22-part2.png', :interlace => true)
  end
end

SporificaToPng.new.draw
