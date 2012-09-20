class CreateGrades < ActiveRecord::Migration
  def change
    create_table :grades do |t|
      t.decimal :grade
	  t.integer :assignment_id
	  t.integer :user_id

      t.timestamps
    end
  end
  
  def down
	drop_table :grades
  end
end
