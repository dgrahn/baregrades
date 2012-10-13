class AddDueDateToGradeScale < ActiveRecord::Migration
  def change
    add_column :grade_scales, :due_date, :date
  end
end
