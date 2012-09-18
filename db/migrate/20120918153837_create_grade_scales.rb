class CreateGradeScales < ActiveRecord::Migration
  def change
    create_table :grade_scales do |t|
      t.integer :course_id
      t.decimal :a_plus
      t.decimal :a
      t.decimal :a_minus
      t.decimal :b_plus
      t.decimal :b
      t.decimal :b_minus
      t.decimal :c_plus
      t.decimal :c
      t.decimal :c_minus
      t.decimal :d_plus
      t.decimal :d
      t.decimal :d_minus
      t.decimal :f_plus
      t.decimal :f
      t.decimal :f_minus

      t.timestamps
    end
  end
end
