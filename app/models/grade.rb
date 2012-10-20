class Grade < ActiveRecord::Base
	attr_accessible :grade
	
	validates :grade, :numericality => true

	belongs_to :assignment
	belongs_to :user
end