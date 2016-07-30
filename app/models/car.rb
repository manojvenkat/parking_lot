class Car < ActiveRecord::Base
  belongs_to :user
  belongs_to :parking_lot
  has_many :tickets

  validates_presence_of :reg_no, :color

  scope :of_color, ->(color) { where(color: color) }

  def self.find_or_create_car(reg_no, color)
    car = Car.find_by(reg_no: reg_no)
    if car.nil?
      car = Car.new(reg_no: reg_no, color: color)
      car.save!
    end
    car
  end
end