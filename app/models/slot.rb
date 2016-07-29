class Slot < ActiveRecord::Base
	belongs_to :parking_space
	has_many :tickets
	belongs_to :car, foreign_key: :current_car_id

	validates_presence_of :parking_slot_id, :parking_space_id

	def mark_unoccupied
		slot.occupied = false
		slot.current_car_id = nil
		slot.save!
	end

	def mark_occupied(car_id)
		slot.occupied = true
		slot.current_car_id = car_id
		slot.save!
	end

	def get_parked_ticket
		tickets.find_by(still_parked: true)
	end

	def get_slot_num(reg_no)
		
	end

end