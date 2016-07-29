class AddParkingSlotIdToSlots < ActiveRecord::Migration
  def change
  	add_column :slots, :parking_slot_id, :integer, null: false, default: 1
  end
end
