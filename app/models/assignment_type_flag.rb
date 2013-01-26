class AssignmentTypeFlag < ActiveRecord::Base
	attr_accessible :disabled

	belongs_to :user
	belongs_to :assignment_type
end
