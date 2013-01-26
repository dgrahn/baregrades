class CreateNotifications < ActiveRecord::Migration
	def change
		create_table :notifications do |t|
			t.integer :user_id
			t.integer :assignment_type_flag_id
			t.integer :assignment_type_id
			t.integer :assignment_flag_id
			t.integer :assignment_id
			t.string  :comments
			t.boolean :read, :null => false, :default => false

			t.timestamps
		end
	end
end
