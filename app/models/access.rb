class Access < ActiveRecord::Base
	attr_accessible :user_id, :role_id, :course_id
	
	validates :user_id, :presence => true, :numericality => true
	validates :role_id, :presence => true, :numericality => true
	
	validates_uniqueness_of :user_id, :scope => [:course_id]
	
	belongs_to :user
	belongs_to :role
	belongs_to :course
end