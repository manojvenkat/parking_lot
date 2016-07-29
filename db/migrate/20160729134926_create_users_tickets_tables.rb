class CreateUsersTicketsTables < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.string :address
    	t.integer :num_visited_times, default: 0, null: false
    	t.string :phone

    	t.timestamps
    end

    create_table :tickets do |t|
    	t.datetime :parked_from, null: false, default: Time.now
    	t.datetime :parked_till
    	t.boolean :still_parked, default: true
    	t.references :user
    	t.references :car, null: false
    	t.references :slot, null: false

    	t.timestamps
    end

    create_table :slots do |t|
    	t.boolean :occupied, default: false
    	t.references :parking_space, null: false

    	t.timestamps
    end

    create_table :cars do |t|
    	t.string :reg_no, unique: true, null: false
    	t.string :color, null: false
    	t.references :user

    	t.timestamps
    end

    create_table :parking_spaces do |t|
    	t.string :name
    	t.integer :slot_count, null: false
    end
  end
end
