class ChangeDataTypeForGradeGrade < ActiveRecord::Migration
  def up
	change_table :grades do |t|
      t.change :grade, :decimal
    end
  end

  def down
      change_table :grades do |t|
		t.change :grade, :integer
	  end
  end
end
