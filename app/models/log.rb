#   File: log.rb
#  Class: Log
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds a single record of a change made to the
# database by a user.
# -----------------------------------------------------------

class Log < ActiveRecord::Base
	belongs_to :user
	belongs_to :course
	belongs_to :assignment_type
	belongs_to :assignment
	belongs_to :grade
	attr_accessible :comments
	attr_accessible :created_at
	
	default_scope order:"created_at DESC"
end
