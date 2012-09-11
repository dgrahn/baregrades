class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :identifier
      t.integer :section
      t.text :description
      t.integer :pin
      t.boolean :student_managed
      t.decimal :credits
      t.boolean :points_based

      t.timestamps
    end
  end
end
