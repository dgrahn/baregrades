class RemoveAPlusAndFFromGradeScale < ActiveRecord::Migration
  def up
    remove_column :grade_scales, :a_plus
    remove_column :grade_scales, :f
  end

  def down
    add_column :grade_scales, :f, :decimal
    add_column :grade_scales, :a_plus, :decimal
  end
end
