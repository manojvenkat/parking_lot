class TicketTest < ActiveSupport::TestCase
  require 'test_helper'

  test "Testing the validation on slot_id, car_id" do
    parking_space = create_parking_space
    car = create_car

    t = Ticket.new
    assert_not t.save

    t = Ticket.new(slot_id: parking_space.slots.last)
    assert_not t.save

    t = Ticket.new(car_id: car.id)
    assert_not t.save
  end

  test "Saving the ticket with the right attributes." do
    parking_space = create_parking_space
    car = create_car

    t = Ticket.new(slot_id: parking_space.slots.last.id, car_id: car.id)
    assert t.save
    assert t.still_parked
    assert (t.slot_id == parking_space.slots.last.id)
    assert (t.car_id == car.id)
  end

  test "Closing ticket." do
    parking_space = create_parking_space
    car = create_car
    slot = parking_space.slots.last

    t = Ticket.new(slot_id: slot.id, car_id: car.id)
    assert t.save
    assert t.still_parked
    
    assert Ticket.close_ticket(slot)
    
    t.reload
    assert_not t.still_parked
    assert t.parked_till.present?
  end
end