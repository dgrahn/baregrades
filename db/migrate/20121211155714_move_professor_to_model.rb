class MoveProfessorToModel < ActiveRecord::Migration
	def change
		remove_column :courses, :professor
		add_column :courses, :professor_id, :integer
	end
end
