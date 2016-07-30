class ParkingSpace < ActiveRecord::Base
  has_many :slots

  validates_presence_of :slot_count

  after_create :create_parking_slots

  module ReturnStrings
    SUCCESS = "SUCCESSFULLY PARKED"
    PARKING_LOT_FULL = "NO EMPTY SLOTS"
    ALLOCATED = "ALLOCATED SLOT NUMBER : "
    ERROR = "ENCOUNTERED AN ERROR!"
    SLOT_FREED = "SLOT NUMBER FREED : "
    NOT_FOUND = "NOT FOUND!"
    INITIALIZATION_ERROR = "PARKING SPACE NOT INITIALIZED!"
  end

  def self.create_parking_lot(slot_count)
    parking_space = ParkingSpace.create!(slot_count: slot_count)
    parking_space
  end

  def create_parking_slots
    (1..slot_count).each do |parking_slot_id|
      slots.create!(parking_slot_id: parking_slot_id)
    end
  end

  def park(reg_no, color)
    begin
      parking_slot = available_unoccupied_slot
      car = Car.find_or_create_car(reg_no, color)
      if parking_slot
        parking_slot.mark_occupied(car.id)

        ticket = parking_slot.tickets.create!(car_id: car.id)

        puts ReturnStrings::SUCCESS
        puts ReturnStrings::ALLOCATED + parking_slot.parking_slot_id.to_s
        return true
      else
        puts ReturnStrings::PARKING_LOT_FULL
        return false
      end
    rescue Exception => e
      puts e
      puts ReturnStrings::ERROR
    end
  end

  def leave(slot_id)
    begin
      slot = slots.find_by(parking_slot_id: slot_id)
      if slot.occupied
        Ticket.close_ticket(slot)
        slot.mark_unoccupied

        puts ReturnStrings::SLOT_FREED + slot.parking_slot_id.to_s
        return true
      else
        return false
      end
    rescue Exception => e
      puts e
      puts ReturnStrings::ERROR
    end
  end

  def status
    status_string = "Slot no.\t Registration No.\t Color\n"
    slots.each do |slot|
      car = Car.find_by(id: slot.current_car_id)
      unless car.nil?
        status_string += "#{slot.parking_slot_id}\t #{car.reg_no}\t #{car.color}\n"
      end
    end
    puts status_string
    status_string
  end

  def registration_numbers_for_cars_with_colour(color)
    cars_parked =  Car.where(id: self.slots.pluck(:current_car_id))
    cars_of_color = cars_parked.where(color: color)
    reg_numbers = cars_of_color.pluck(:reg_no).join(', ')
    return_string = reg_numbers.present? ? reg_numbers : ReturnStrings::NOT_FOUND
    puts return_string
    return_string
  end

  def slot_numbers_for_cars_with_colour(color)
    slots_cars = slots.pluck(:current_car_id, :parking_slot_id).select{|a| a[0].present? }

    slots_cars_hash = Hash.new
    slots_cars.each{ |k,v| slots_cars_hash[k] = v }

    car_ids = slots.pluck(:current_car_id)
    car_ids_of_color = Car.where(id: car_ids).where(color: color).pluck(:id)
    
    slots = []
    car_ids_of_color.each do |car_id|
      slots << slots_cars_hash[car_id]
    end

    puts slots.map(&:inspect).join(', ')
    slots
  end

  def slot_number_for_registration_number(reg_no)
    car = Car.find_by(reg_no: reg_no)
    if car.present?
      slot = slots.find_by(current_car_id: car.id)
      if slot.present?
        puts slot.parking_slot_id
        return slot.parking_slot_id
      end
    end
    puts ParkingSpace::ReturnStrings::NOT_FOUND
  end

  private

  def available_unoccupied_slot
    slots.where(occupied: false).order("parking_slot_id ASC").first
  end

end
