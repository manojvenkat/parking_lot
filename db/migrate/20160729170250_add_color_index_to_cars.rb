class AddColorIndexToCars < ActiveRecord::Migration
  def change
  	add_index :cars, :color
  end
end
