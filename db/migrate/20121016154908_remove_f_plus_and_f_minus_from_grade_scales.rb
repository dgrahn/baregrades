class RemoveFPlusAndFMinusFromGradeScales < ActiveRecord::Migration
  def up
    remove_column :grade_scales, :f_minus
    remove_column :grade_scales, :f_plus
  end

  def down
    add_column :grade_scales, :f_plus, :decimal
    add_column :grade_scales, :f_minus, :decimal
  end
end
