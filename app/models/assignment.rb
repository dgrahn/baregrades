class Assignment < ActiveRecord::Base
	attr_accessible :description, :name, :worth, :assignment_type_id, :due_date

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true
	validates_length_of :description, :maximum => 144
	
	belongs_to :assignment_type
	
	has_many :grades
	

	def user_grade(user)
		grade = Grade.where(:assignment_id => self.id, :user_id => user.id).first
		
		if grade
			return grade.grade
		end
	end
	
	def user_percentage(user)
		worth 		= self.worth
		grade 		= self.user_grade(user)
		
		if !grade.blank? && !worth.blank?
			percent 	= (grade.to_f / worth.to_f) * 100
			return percent
		end
	end
	
	def course
		return self.assignment_type.course
	end
end