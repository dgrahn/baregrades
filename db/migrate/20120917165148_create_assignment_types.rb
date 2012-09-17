class CreateAssignmentTypes < ActiveRecord::Migration
  def change
    create_table :assignment_types do |t|
      t.integer :course_id
      t.string :name
      t.text :description
      t.decimal :worth

      t.timestamps
    end
  end
end
