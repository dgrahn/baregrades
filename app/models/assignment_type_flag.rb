#   File: assignment_type_flag.rb
#  Class: AssignmentTypeFlag
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds information for assignment type flags.
# Assignment type flags hold user specific information for assignment types.
# -----------------------------------------------------------
class AssignmentTypeFlag < ActiveRecord::Base
	attr_accessible :disabled

	belongs_to :user
	belongs_to :assignment_type
end
