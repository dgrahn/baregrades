class Course < ActiveRecord::Base
	attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed

	has_one :grade_scale
	has_many :access
	has_many :users, :through => :access
	has_many :assignment_types

	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
		self.assignment_types.each do |type|
			grade = type.user_grade(user)
			if grade
				totalGrade += grade
				totalWorth += 100
			end
		end

		if totalWorth != 0
			return  totalGrade / totalWorth * 100
		end
	end
end