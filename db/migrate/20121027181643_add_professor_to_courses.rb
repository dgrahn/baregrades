class AddProfessorToCourses < ActiveRecord::Migration
	def change
		add_column :courses, :professor, :text
	end
end
