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
		cars_parked =  Car.where(id: self.slots.pluck(:current_car_id))
		cars_of_color = cars_parked.where(color: color)
		reg_numbers = cars_of_color.pluck(:reg_no).map(&:inspect).join(', ')
		reg_numbers.present? ? reg_numbers : ReturnStrings::NOT_FOUND
	end

	def get_slot_nums_with_cars_of_color(color)
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
	end
end