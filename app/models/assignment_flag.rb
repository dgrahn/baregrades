class AssignmentFlag < ActiveRecord::Base
	attr_accessible :assignment_id, :disabled, :user_id

	validates :user_id, :presence => true, :numericality => true
	validates :assignment_id, :presence => true, :numericality => true
	
	validates_uniqueness_of :user_id, :scope => [:assignment_id]
	
	belongs_to :user
	belongs_to :assignment

end
