#   File: assignment_flag.rb
#  Class: AssignmentFlag
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds information for assignment flags.
# Assignment flags hold user specific information for assignments.
# -----------------------------------------------------------

class AssignmentFlag < ActiveRecord::Base
	attr_accessible :disabled

	validates :user_id, :presence => true, :numericality => true
	validates :assignment_id, :presence => true, :numericality => true
	
	validates_uniqueness_of :user_id, :scope => [:assignment_id]
	
	belongs_to :user
	belongs_to :assignment

end
