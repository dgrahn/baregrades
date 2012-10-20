class AssignmentType < ActiveRecord::Base
	attr_accessible :description, :name, :worth, :course_id

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true

	belongs_to :course
	has_many :assignments

	def sorted_assignments
		return self.assignments.order("due_date")
	end
	
	def user_grade(user)
		totalGrade = 0
		totalWorth = 0
		self.assignments.each do |assignment|
			grade = assignment.user_grade(user)
			if grade
				totalGrade += grade
				totalWorth += assignment.worth
			end
		end

		if totalWorth != 0
			return  totalGrade.to_f / totalWorth.to_f * 100
		end
	end
end