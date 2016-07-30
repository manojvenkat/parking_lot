class SlotTest < ActiveSupport::TestCase
  require 'test_helper'

  test "Test the validation of :parking_slot_id, :parking_space_id" do
    parking_space = create_parking_space

    slot = Slot.new
    assert_not slot.save

    slot = Slot.new(parking_space_id: parking_space.id, parking_slot_id: nil)
    assert_not slot.save

    slot = Slot.new(parking_slot_id: 1)
    assert_not slot.save

    slot = parking_space.slots.new
    assert slot.save
  end

  test "Test the occupation function for a slot" do
    parking_space = create_parking_space
    car = create_car
    slot = parking_space.slots.last

    assert_not slot.occupied
    
    assert slot.mark_occupied(car.id)
    assert slot.occupied
    assert (slot.current_car_id == car.id)
  end

  test "Test the leaving function for a slot" do
    parking_space = create_parking_space
    car = create_car
    slot = parking_space.slots.last

    assert_not slot.occupied
    
    assert slot.mark_occupied(car.id)
    assert slot.occupied
    assert (slot.current_car_id == car.id)

    assert slot.mark_unoccupied
    assert_not slot.occupied
    assert slot.current_car_id.nil?
  end

  test "Test the get_parked_ticket function" do
    parking_space = create_parking_space
    car = create_car
    slot = parking_space.slots.last

    t = Ticket.new(slot_id: slot.id, car_id: car.id)
    slot.mark_occupied(car.id)

    assert t.save
    assert t.still_parked
    assert (slot.get_parked_ticket.id == t.id)
    assert (slot.current_car_id == car.id)
  end

  test "Test the get_parked_ticket function on an unoccupied slot." do
    parking_space = create_parking_space
    car = create_car
    empty_slot = parking_space.slots.first

    assert empty_slot.current_car_id.nil?
    assert empty_slot.get_parked_ticket.nil?
    assert_not empty_slot.occupied
  end
end