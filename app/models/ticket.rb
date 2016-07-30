class Ticket < ActiveRecord::Base
  belongs_to :slot
  belongs_to :car
  belongs_to :user

  validates_presence_of :slot_id, :car_id

  scope :still_parked_tickets, -> { where(still_parked: true) }

  def self.close_ticket(slot)
    ticket = slot.tickets.order("created_at DESC").first
    ticket.still_parked = false
    ticket.parked_till = Time.now
    ticket.save
  end
end