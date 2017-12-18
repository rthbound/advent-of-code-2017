require 'pry'
register = "a".upto("z").to_a.zip([0]*26).to_h

@registers = {
  0 => { register: register.dup, queue: [], counter: 0, sent_log: []},
  1 => { register: register.dup, queue: [], counter: 0, sent_log: []}
}

@registers[0][:register]["p"] = 0
@registers[1][:register]["p"] = 1

def relay_instructions(set)
  instructions = set.scan /(\w{3}) ([+-]?\w+),? ?([+-]?\w+)?/

  ret = loop do
    if (@registers[0][:counter] < 0 || @registers[0][:counter] >= instructions.length) && (@registers[1][:counter] < 0 || @registers[1][:counter] >= instructions.length)
      puts "HRMM... AMBIGUOUS"
      break(@registers)
    end

    raised = 0
    [0,1].each { |k|
      begin
        dispatch *instructions[@registers[k][:counter]], k
      rescue EOFError
        raised += 1
      end
    }

    if raised == 2
      puts "ANSWER FORTHCOMING"
      break @registers[1][:sent_log].length
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
    @registers[k][:register][c]
  end
end

def set(x,y,k)
  @registers[k][:register][x] = terp(y, k)
  @registers[k][:counter] += 1
end

def add(x,y,k)
  @registers[k][:register][x] += terp(y, k)
  @registers[k][:counter] += 1
end

def mul(x,y,k)
  @registers[k][:register][x] *= terp(y, k)
  @registers[k][:counter] += 1
end

def mod(x,y,k)
  @registers[k][:register][x] = @registers[k][:register][x] % terp(y, k)
  @registers[k][:counter] += 1
end

def rcv(x,_,k)
  if @registers[k][:queue].empty?
    raise EOFError
  else #if !terp(x,k).zero?
    @registers[k][:register][x] = @registers[k][:queue].shift
  end
  @registers[k][:counter] += 1
end

def snd(x,_,k)
  @registers[[1,0][k]][:queue] << terp(x,k)
  @registers[k][:sent_log] << terp(x,k)
  @registers[k][:counter] += 1
end

def jgz(x,y,k)
  if terp(x,k) > 0
    @registers[k][:counter] += terp(y,k)
  else
    @registers[k][:counter] += 1
  end
end

puts relay_instructions(File.read("input.txt"))
