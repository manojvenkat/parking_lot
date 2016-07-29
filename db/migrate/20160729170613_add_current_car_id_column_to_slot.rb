class AddCurrentCarIdColumnToSlot < ActiveRecord::Migration
  def change
  	add_column :slots, :current_car_id, :integer
  end
end
