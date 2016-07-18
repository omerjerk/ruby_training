require "./rover.rb"
require "test/unit"

class TestRover < Test::Unit::TestCase

  def test_rover_1()
    rover = Rover.new(1, 2, "N")
    navigate(rover, "LMLMLMLMM")
    assert_equal(1, rover.x)
    assert_equal(3, rover.y)
    assert_equal("N", rover.f)
  end

  def test_rover_2()
  	rover = Rover.new(3, 3, "E")
  	navigate(rover, "MMRMMRMRRM")
  	assert_equal(5, rover.x)
  	assert_equal(1, rover.y)
  	assert_equal("E", rover.f)
  end
end
