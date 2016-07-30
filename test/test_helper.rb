ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def create_parking_space(slot_count=9)
  	parking_space = ParkingSpace.create!(name: "ParkingSpace", slot_count: slot_count)
  	parking_space
  end

  def create_car(reg_no="KA51IO1992", color="red")
  	car = Car.create!(reg_no: reg_no, color: color)
  	car
  end
end
