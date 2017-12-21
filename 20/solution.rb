require "minitest/autorun"
require 'matrix'
require 'set'
require 'pry'
class Particle
  attr_accessor :position, :velocity, :acceleration
  def initialize(line)
    l = line.scan(/-?\d+,-?\d+,-?\d+/).map {|l| l.split(?,) }

    @position     = Matrix[l[0].map(&:to_i)]
    @velocity     = Matrix[l[1].map(&:to_i)]
    @acceleration = Matrix[l[2].map(&:to_i)]
  end

  def tick
    @velocity += @acceleration
    @position += @velocity
  end

  def next_velocity
    velocity + acceleration
  end

  def next_position
    next_velocity + position
  end

  def magnitude(property)
    send(property).to_a.flatten.map(&:abs).sum
  end

  def position_at(t)
    (0.5 * acceleration * (t**2)) + (velocity * t) + position
  end

  def to_s
    "p=<#{position.to_a.flatten.join(",")}>, v=<#{velocity.to_a.flatten.join(",")}>, a=<#{acceleration.to_a.flatten.join(",")}>"
  end
end

class ParticleTest < Minitest::Test
  def test_instantiation
    str = "p=<5528,2008,1661>, v=<-99,-78,-62>, a=<-17,-2,-2>"
    subject = Particle.new(str)
    assert_equal Matrix[[5528,2008,1661]], subject.position
    assert_equal Matrix[[-99,-78,-62]],    subject.velocity
    assert_equal Matrix[[-17,-2,-2]],       subject.acceleration
    assert_equal str, subject.to_s
  end
end

class ShawarmaTest < Minitest::Test
  def test_instantiation
    assert_equal File.readlines("input.txt").size, Shawarma.new("input.txt").particles.length
  end
end

class Shawarma
  attr_accessor :particles, :escaped_particles
  def initialize(filename)
    lines = File.readlines(filename)

    @particles = lines.map {|l| Particle.new(l) }
    @escaped_particles = Set.new
  end

  def sorted_particles
    #particles.sort {|a,b| x = a.position.to_a.flatten; y = b.position.to_a.flatten; Math.sqrt(x[0]**2 + x[1]**2 + x[2]**2) <=> Math.sqrt(y[0]**2 + y[1]**2 + y[2]**2) }
    particles.sort {|b,a| a.position.to_a.flatten.map(&:abs).sum <=> b.position.to_a.flatten.map(&:abs).sum }
  end

  def min_distance
    particles.map {|p| p.magnitude(:position) }.min
  end

  def min_distance_to_com(com)
    nearest_to_com = particles.map(&:position).min_by {|x| (com[0] - x[0,0]).abs + (com[1] - x[0,1]).abs + (com[2] - x[0,2]).abs }

    (com[0] - nearest_to_com[0,0]).abs + (com[1] - nearest_to_com[0,1]).abs + (com[2] - nearest_to_com[0,2]).abs
  end

  def max_distance_from_com(com)
    nearest_to_com = particles.max_by {|x| (com[0] - x.position[0,0]).abs + (com[1] - x.position[0,1]).abs + (com[2] - x.position[0,2]).abs }
  end

  def call
    i        = 0

    ret = loop do
      i += 1
      puts "T=#{i} and #{@escaped_particles.size} escaped, #{1000 - (@particles.size + @escaped_particles.size)} destroyed, #{@particles.size} still at risk"
      @particles.each(&:tick)
      @particles = @particles.group_by{|x| x.position }.select {|k,v| v.length == 1}.values.flatten

      if @particles.size == 0
        break(@escaped_particles)
      end


      loop do
        escapees = [
          particles.max_by {|x| x.magnitude(:velocity)     },
          particles.max_by {|x| x.magnitude(:acceleration) },
          particles.max_by {|x| x.magnitude(:position    ) },
        ].uniq

        #if largest_p == largest_v && largest_v.magnitude(:acceleration) == largest_a.magnitude(:acceleration)
        if escapees.map {|e| e.magnitude(:acceleration) }.uniq.length == 1
          @particles = @particles - escapees
          @escaped_particles ^= escapees
        else
          break
        end
        break if @particles.size == 0
      end
    end
  end

  def particle_count
    @particles.size
  end
end

puts Shawarma.new("input.txt").call.size
