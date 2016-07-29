class RemoveNullValidationTickets < ActiveRecord::Migration
  def change
  	change_column :tickets, :parked_till, :datetime, :null => true
  end
end
