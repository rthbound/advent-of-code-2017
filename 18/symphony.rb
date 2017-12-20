require 'pry'

class Symphony
  attr_accessor :symphony
  def initialize(sheet_music, players = 2, favorite_musician = 1)
    @favorite_musician = favorite_musician
    template_register = "a".upto("z").to_a.zip([0]*26).to_h
    @symphony = 0.upto(players - 1).to_a.zip(players.times.map {
      {
        queue:    [],
        sent_log: [],
        register: template_register.dup,
        counter:  0,
      }
    }).to_h

    @sheet_music = File.read sheet_music

    initialize_first_chairs
  end

  def conduct
    attack(@sheet_music)
  end

  private
  def attack(sheet)
    notes = sheet.scan /(\w{3}) ([+-]?\w+),? ?([+-]?\w+)?/

    ret = loop do
      if (@symphony[0][:counter] < 0 || @symphony[0][:counter] >= notes.length) && (@symphony[1][:counter] < 0 || @symphony[1][:counter] >= notes.length)
        puts "HRMM... AMBIGUOUS"
        break(@symphony)
      end

      raised = 0
      @symphony.keys.each { |k|
        begin
          dispatch *notes[@symphony[k][:counter]], k
        rescue EOFError
          raised += 1
        end
      }

      if raised == symphony.size
        break @symphony[@favorite_musician][:sent_log].length
      end
    end
  end

  def dispatch(instruction, parm1, parm2, k)
    send(instruction, parm1, parm2, k)
  end

  def terp(c, k)
    case c
    when /-?\d+/
      c.to_i
    when /\w/
      @symphony[k][:register][c]
    end
  end

  def set(x,y,k)
    @symphony[k][:register][x] = terp(y, k)
    @symphony[k][:counter] += 1
  end

  def add(x,y,k)
    @symphony[k][:register][x] += terp(y, k)
    @symphony[k][:counter] += 1
  end

  def mul(x,y,k)
    @symphony[k][:register][x] *= terp(y, k)
    @symphony[k][:counter] += 1
  end

  def mod(x,y,k)
    @symphony[k][:register][x] = @symphony[k][:register][x] % terp(y, k)
    @symphony[k][:counter] += 1
  end

  def rcv(x,_,k)
    if @symphony[k][:queue].empty?
      raise EOFError
    else #if !terp(x,k).zero?
      @symphony[k][:register][x] = @symphony[k][:queue].shift
    end
    @symphony[k][:counter] += 1
  end

  def snd(x,_,k)
    (@symphony.keys - [k]).each {|r| @symphony[r][:queue] << terp(x,k) }
    @symphony[k][:sent_log] << terp(x,k)
    @symphony[k][:counter] += 1
  end

  def jgz(x,y,k)
    if terp(x,k) > 0
      @symphony[k][:counter] += terp(y,k)
    else
      @symphony[k][:counter] += 1
    end
  end

  def initialize_first_chairs
    @symphony.each {|k,v|
      v[:register]['p'] = k
    }
  end
end

puts "Day 18 part two: #{Symphony.new("input.txt").conduct}"
