class CreateLogs < ActiveRecord::Migration
	def up
		create_table :logs do |t|
			t.integer :user_id
			t.integer :course_id
			t.integer :assignment_type_id
			t.integer :assignment_id
			t.integer :grade_id
			t.string  :comments
			t.timestamps
		end
	end

	def down
		drop_table :logs
	end
end
