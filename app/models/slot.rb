class Slot < ActiveRecord::Base
  belongs_to :parking_space
  has_many :tickets
  belongs_to :car, foreign_key: :current_car_id

  validates_presence_of :parking_slot_id, :parking_space_id
  scope :unoccupied, -> { where(occupied: false) }

  def mark_unoccupied
    self.occupied = false
    self.current_car_id = nil
    self.save
  end

  def mark_occupied(car_id)
    self.occupied = true
    self.current_car_id = car_id
    self.save
  end

  def get_parked_ticket
    self.tickets.find_by(still_parked: true)
  end
end