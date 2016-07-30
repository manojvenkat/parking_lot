class ParkingSpaceTest < ActiveSupport::TestCase

  test "Test the validation on slot_count while creating a parking space." do
    parking_space = ParkingSpace.new
    assert_not parking_space.save

    parking_space.slot_count = 10
    assert parking_space.save
  end

  test "Test the creation of slots" do 
    parking_space = ParkingSpace.new
    parking_space.slot_count = 10
    assert parking_space.save

    parking_space.reload
    assert parking_space.slots.count, parking_space.slot_count
  end

  test "Test the parking of a vehicle when there's vacany." do
    parking_space = create_parking_space
    car = create_car
    first_slot = parking_space.slots.order("parking_slot_id ASC").first

    assert parking_space.park(car.reg_no, car.color)
    first_slot.reload
    assert first_slot.occupied
    assert first_slot.current_car_id
    assert first_slot.get_parked_ticket.present?
  end

  test "Test the parking of a vehicle when there's no vacancy" do
    parking_space = create_parking_space(1)
    car = create_car

    assert (parking_space.slots.count == 1)
    first_slot = parking_space.slots.order("parking_slot_id ASC").first

    assert parking_space.park(car.reg_no, car.color)
    first_slot.reload
    assert first_slot.occupied
    assert first_slot.current_car_id
    assert first_slot.get_parked_ticket.present?

    another_car = create_car("AP51OI0909", 'white')
    assert (parking_space.slots.unoccupied.count == 0)
    assert_not parking_space.park(another_car.reg_no, another_car.color)
  end

  test "Test the leaving of a vehicle for a slot that's filled." do
    parking_space = create_parking_space(1)
    car = create_car

    assert (parking_space.slots.count == 1)
    first_slot = parking_space.slots.order("parking_slot_id ASC").first

    assert parking_space.park(car.reg_no, car.color)
    first_slot.reload
    assert first_slot.occupied
    assert first_slot.current_car_id
    assert first_slot.get_parked_ticket.present?
  
    assert parking_space.leave(first_slot.parking_slot_id)
    first_slot.reload
    assert_not first_slot.occupied
    assert first_slot.current_car_id.nil?
    assert_not first_slot.get_parked_ticket.present?
  end

  test "Test the leaving of a vehicle for a slot that's not filled." do
    parking_space = create_parking_space(1)
    car = create_car

    first_slot = parking_space.slots.order("parking_slot_id ASC").first
    
    assert (parking_space.slots.count == 1)
    assert_not first_slot.occupied
    assert_not parking_space.leave(first_slot.id)
  end

  test "Test the status feature of the parking space." do
    parking_space = create_parking_space(1)
    car = create_car

    assert (parking_space.slots.count == 1)
    first_slot = parking_space.slots.order("parking_slot_id ASC").first

    assert parking_space.park(car.reg_no, car.color)
    first_slot.reload
    assert first_slot.occupied
    assert first_slot.current_car_id
    assert first_slot.get_parked_ticket.present?

    status_string = "Slot no.\t Registration No.\t Color\n"
    parking_space.slots.each do |slot|
      car = Car.find_by(id: slot.current_car_id)
      unless car.nil?
        status_string += "#{slot.parking_slot_id}\t #{car.reg_no}\t #{car.color}\n"
      end
    end

    assert (status_string == parking_space.status)
  end

  test "Test the registration_numbers_for_cars_with_colour" do
    parking_space = create_parking_space(1)
    car = create_car("loop", "red")

    parking_space.park(car.reg_no, car.color)
    assert (parking_space.registration_numbers_for_cars_with_colour("red") == car.reg_no)
  end

  test "Test the slot_numbers_for_cars_with_colour" do
    parking_space = create_parking_space(1)
    car = create_car("loop", "red")
    slot_id = parking_space.slots.last.id

    parking_space.park(car.reg_no, car.color)

    assert (parking_space.slot_numbers_for_cars_with_colour("red").include? slot_id)
  end

  test "Test the slot_number_for_registration_number" do
    parking_space = create_parking_space(1)
    car = create_car("loop", "red")
    slot_id = parking_space.slots.last.id

    parking_space.park(car.reg_no, car.color)
    parking_space.reload
    assert (parking_space.slot_number_for_registration_number("loop") == slot_id)
  end
end