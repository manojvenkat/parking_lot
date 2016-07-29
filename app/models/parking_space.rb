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
	end

	def create_parking_slots
		(1..slot_count).each do |parking_slot_id|
			slots.create!(parking_slot_id: parking_slot_id)
		end
	end

	def available_unoccupied_slot
		slots.where(occupied: false).order("parking_slot_id ASC").first
	end

	def park_car(reg_no, color)
		begin
			parking_slot = available_unoccupied_slot
			car = Car.find_or_create_car(reg_no, color)
			if parking_slot
				parking_slot.mark_occupied(car.id)

				ticket = parking_slot.tickets.new(car_id: car.id)
				ticket.save!

				puts ReturnStrings::SUCCESS
				puts ReturnStrings::ALLOCATED + parking_slot.parking_slot_id.to_s
			else
				puts ReturnStrings::PARKING_LOT_FULL
			end
		rescue Exception => e
			puts e
			puts ReturnStrings::ERROR
		end
	end

	def leave_car(slot_id)
		begin
			slot = slots.find_by(parking_slot_id: slot_id)

			Ticket.close_ticket(slot)
			slot.mark_occupied

			puts ReturnStrings::SLOT_FREED + slot.parking_slot_id.to_s
		rescue Exception => e
			puts e
			puts ReturnStrings::ERROR
		end
	end

	def status
		slots.each do |slot|
			car = Car.find(slot.current_car_id)
			puts "Slot no.\t Registration No.\t Color\n"
			unless parked_ticket.nil?
				puts "#{slot.parking_slot_id}\t #{car.reg_no}\t #{car.color}\n"
			end
		end
	end

	def get_cars_of_color(color)
		puts Car.where(id: slots.pluck(:current_car_id)).where(color: color).pluck(:reg_no)
	end

end