require "./rover.rb"
require "test/unit"

class TestRover < Test::Unit::TestCase

  def test_rover_1
    rover = Rover.new(1, 2, "N")
    navigate(rover, "LMLMLMLMM")
    assert_equal(1, rover.x)
    assert_equal(3, rover.y)
    assert_equal("N", rover.f)
  end

  def test_rover_2
  	rover = Rover.new(3, 3, "E")
  	navigate(rover, "MMRMMRMRRM")
  	assert_equal(5, rover.x)
  	assert_equal(1, rover.y)
  	assert_equal("E", rover.f)
  end

  def test_change_direction
  	assert_equal("S", change_direction("E", "R"))
  	assert_equal("S", change_direction("W", "L"))
  	assert_equal("N", change_direction("E", "L"))
  	assert_equal("N", change_direction("W", "R"))
  end

  def test_calc_direction
  	assert_equal([0, 1], calc_direction("N"))
  	assert_equal([1, 0], calc_direction("E"))
  end
end
