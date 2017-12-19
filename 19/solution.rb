require 'pry'
@input = "test_input.txt"
@input = "input.txt"
File.readlines(@input).map {|x| x.gsub("\n", "")}
@hash = {}; File.readlines(@input).map {|x| x.gsub("\n", "")}.each_with_index {|row,y| row.each_char.with_index {|char,x| @hash[Complex(x,y)] = char }}
@current_vector = Complex(0,1)
@passed = []
@rotator = [1,0]
@steps = 0

@stops = File.read(@input).scan(/[A-Z]/)

@el = @hash.detect {|k,v| k.imag == 0 && v == "|"}[0]

def process
  case @hash[@el]
  when /[|-]/
    @el += @current_vector
  when /[A-Z]/
    @passed << @hash[@el]
    raise EOFError if @stops & @passed == @stops
    @el += @current_vector
  when "+"
    if @hash.fetch(@el + Complex(@rotator[@current_vector.real], @rotator[@current_vector.imag])) { " " } != " "
      @current_vector = Complex(@rotator[@current_vector.real], @rotator[@current_vector.imag])
      @el += @current_vector
    elsif @hash.fetch(@el + Complex(-@rotator[@current_vector.real], -@rotator[@current_vector.imag])) { " " } != " "
      @current_vector = Complex(-@rotator[@current_vector.real], -@rotator[@current_vector.imag])
      @el += @current_vector
    else
      raise "TUBULAR"
    end
  else
    raise "TUBULAR"
  end
end

ret = loop do
  begin
    @steps += 1
    process
  rescue EOFError
    puts @passed.join
    puts @steps
    break @passed.join
  end
end

#class World
#  attr_accessor :map
#  def initialize(file)
#    inp  = File.read(file)
#    puts inp
#    inp  = inp.rstrip.scan /.+/
#
#    @map = {}
#    inp.each_with_index {|row,y| row.each_char.with_index {|char,x| @map[Complex(x,y)] = char } }
#  end
#
#  def destinations
#    map.select {|k,v| v[/\d+/] }.keys - [home]
#  end
#
#  def home
#    map.detect {|k,v| v == "0" }[0]
#  end
#end
#
#class WorldTraveler
#  def initialize(grid)
#    @grid = grid
#    @known_traversals = {}
#  end
#
#
#  def travel_time(start, finish = nil)
#    @known_traversals.fetch([start,finish]) {
#      frontier  = [] << start
#      came_from = {}
#
#      came_from[start] = nil
#
#      while !frontier.empty? do
#        current = frontier.shift
#
#        neighbors(current).each do |n|
#          unless came_from.has_key? n
#            frontier << n
#            came_from[n] = current
#          end
#        end
#      end
#
#      current = finish
#      path    = []
#      while current != start do
#        path << current
#        current = came_from[current]
#      end
#
#      @known_traversals[[start,finish]] = path.length
#    }
#  end
#
#  private
#
#  def neighbors(coord)
#    [
#      coord + (0+1i), # Up
#      coord + (0-1i), # Down
#      coord + (1-0i), # Right
#      coord - (1+0i), # Left
#    ].select do |c|
#      @grid.fetch(c) { "#" } != "#"
#    end
#  end
#end
#
#class TravelAgent
#  def initialize(world, first_class = WorldTraveler)
#    @world       = world
#    @first_class = first_class.new(world.map)
#  end
#
#  def whats_the_damage?
#    travel_logs = @world.destinations.permutation(@world.destinations.length).each.map { |schedule|
#      [
#        schedule,
#        @first_class.travel_time(@world.home, schedule[0]) +
#        schedule.each_cons(2).map {|leg|
#          @first_class.travel_time(leg.first, leg.last)
#        }.sum
#      ]
#    }.to_h
#
#    favorite_trip = travel_logs.detect { |k,v|
#      v == travel_logs.values.min
#    }
#
#    {
#      globetrotting: favorite_trip[-1],
#      return_flight: @first_class.travel_time(favorite_trip[0][-1], @world.home)
#    }
#  end
#end
#
#world = World.new("test_input.txt")
#print "Sample: "
#puts TravelAgent.new(world).whats_the_damage?[:globetrotting]
#
#world = World.new("input.txt")
#damage = TravelAgent.new(world).whats_the_damage?
#puts "P1: #{damage[:globetrotting]}"
