class Assignment < ActiveRecord::Base
	attr_accessible :description, :name, :worth, :assignment_type_id, :due_date

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true
	validates_length_of :description, :maximum => 144

	has_many :grades
	belongs_to :assignment_type

	def user_grade(user)
		grade = Grade.where(:assignment_id => self.id, :user_id => user.id).first
		
		if grade
			return grade.grade
		end
	end
	
	def user_percentage(user)
		assignment 	= Assignment.find(self.id)
		worth 		= assignment.worth
		grade 		= assignment.user_grade(user)
		
		if !grade.blank? && !worth.blank?
			percent 	= (grade / worth) * 100
			return percent
		end
	end
end
