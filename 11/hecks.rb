require 'matrix'
class Hecks
  def initialize(instructions)
    @position             = Matrix[[0,0,0]]
    @max_distance_reached = current_distance
    @instructions         = instructions.scan /\w+/
    @hecks_pad            = {
                               ?n  => Matrix[[0,1,-1]],
      "nw" => Matrix[[-1,1,0]],                        "ne" => Matrix[[1,0,-1]],
#                                   \         /
#------------------------------------@position---------------------------------
#                                   /         \
      "sw" => Matrix[[-1,0,1]],                        "se" => Matrix[[1,-1,0]],
                               ?s  => Matrix[[0,-1,1]],
    }
  end

  def call
    traverse and { distance: current_distance, max_distance_reached: @max_distance_reached }
  end

  private
  def traverse
    @instructions.each { |direction|
      @position += @hecks_pad[direction] and reach_new_distance
    }
  end

  def current_distance
    0.5 * (
      (0 - @position[0,0]).abs +
      (0 - @position[0,1]).abs +
      (0 - @position[0,2]).abs
    )
  end

  def reach_new_distance
    # Hecken good distance. Let's keep up with the max.
    @max_distance_reached = [@max_distance_reached, current_distance].max
  end
end

input = File.read("input.txt")
puts Hecks.new(input).call
        ##############################                                     #############################
       #### Y                      ####                                   #### Y                     ####
     ####                            ####                               ####                           ####
   ####                                ####                           ####                               ####
 ####                                    #### Z                     ####                                   #### Z
###                                       #############################                                     ######
###                                     X #############################                                   X ######
###                                       #############################                                     ######
 ####                                    #### Y                     ####                                   #### Y
   ####                                ####                           ####                               ####
     ####                            ####                               ####                           ####
       #### Z                      ####                                   #### Z                     ####
        ##############################                                     #############################
        ##############################                                   X #############################
        ##############################                                     #############################
       #### Y                      ####                                   #### Y                     ####
     ####                            ####                               ####                           ####
   ####                                ####                           ####                               ####
 ####                                    #### Z                     ####                                   #### Z
###                                       #############################                                     ######
###                                     X #############################                                   X ######
###                                       #############################                                     ######
 ####                                    #### Y                     ####                                   #### Y
   ####                                ####                           ####                               ####
     ####                            ####                               ####                           ####
       #### Z                      ####                                   #### Z                     ####
        ##############################                                     #############################
        ##############################                                   X #############################
