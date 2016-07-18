#!/usr/bin/ruby

class Rover
  attr_accessor :x
  attr_accessor :y
  attr_accessor :f

  def initialize(x, y, f)
    @x = x
    @y = y
    @f = f
  end
end

upper, right = gets.split.map(&:to_i)

def calc_direction(direction)
  case direction
  when "N"
    return 0, 1
  when "E"
    return 1, 0
  when "S"
    return 0, -1
  when "W"
    return -1, 0
  end
end

def change_direction(direction, change)
  maps = {
    "N" => 0,
    "E" => 1,
    "S" => 2,
    "W" => 3
  }

  arr = ["N", "E", "S", "W"]

  if change == "L"
    return arr[maps[direction] - 1]
  else
    return arr[(maps[direction] + 1)%4]
  end

end

def navigate(rover, directions)
  dir_x, dir_y = calc_direction(rover.f)

  directions.split("").each {|c|
    if c == "M"
      rover.x += dir_x
      rover.y += dir_y
    else
      rover.f = change_direction(rover.f, c)
      dir_x, dir_y = calc_direction(rover.f)
    end

  }
end



#number of rovers
n = gets.to_i

(0...n).each  do |i|
  x, y, f = gets.chomp.split(/ /)
  x = x.to_i
  y = y.to_i

  rover = Rover.new(x, y, f)

  directions = gets.chomp

  navigate(rover, directions)

  puts "#{rover.x} #{rover.y} #{rover.f}"
end
