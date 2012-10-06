class Assignment < ActiveRecord::Base
	attr_accessible :description, :name, :worth

	validates :name, :presence => true
	validates :worth, :presence => true, :numericality => true

	has_many :grades
	belongs_to :assignment_type
end
