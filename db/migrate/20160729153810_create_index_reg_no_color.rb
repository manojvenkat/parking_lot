class CreateIndexRegNoColor < ActiveRecord::Migration
  def change
    create_table :index_reg_no_colors do |t|
    	add_index :cars, :reg_no
    end
  end
end
