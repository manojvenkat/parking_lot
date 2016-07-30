class CarTest < ActiveSupport::TestCase
  require 'test_helper'

  test "Shouldn't create/save a car with reg_no or color" do
    c = Car.new
    assert_not c.save

    c.reg_no = "Whatever"
    assert_not c.save

    c.reg_no = nil
    c.color = "Purple"
    assert_not c.save    
  end

  test "Should be able to save a car with reg_no & color" do
    c = Car.new
    c.reg_no = "Whatever"
    c.color = "Purple"
    assert c.save
  end

  test "Create a new car if it's not found. If it's found don't create one." do
    car_count = Car.count
    
    car = Car.find_or_create_car("Whatever", "Purple")
    car_count = Car.count
    assert (car_count == 1)

    car = Car.find_or_create_car("Whatever", "Purple")
    car_count = Car.count
    assert (car_count == 1)
  end
end
