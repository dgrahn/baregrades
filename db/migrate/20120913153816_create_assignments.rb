class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.string :name
      t.text :description
      t.decimal :worth
    end
  end
  
  def down
	drop_table :assignments
  end
end
