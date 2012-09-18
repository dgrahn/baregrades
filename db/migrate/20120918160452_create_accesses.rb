class CreateAccesses < ActiveRecord::Migration
  def change
	create_table :accesses do |t|
		t.integer :user_id
		t.integer :role_id
		t.integer :course_id
	end
  end
end
