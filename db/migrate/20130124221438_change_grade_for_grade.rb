class ChangeGradeForGrade < ActiveRecord::Migration
	def up
		change_column :grades, :grade, :float
	end

	def down
		change_column :grades, :grade, :integer
	end
end
