class Assignment < ActiveRecord::Base
	attr_accessible :description, :name, :worth, :assignment_type_id

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true

	has_many :grades
	belongs_to :assignment_type

	def user_grade(user)
		grade = Grade.where(:assignment_id => self.id, :user_id => user.id).first
		
		if grade
			return grade.grade
		end
	end
end
