#   File: notification.rb
#  Class: Notification
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds the noticiations for a user which will be
# displayed in the notifications window.
# -----------------------------------------------------------

class Notification < ActiveRecord::Base
	attr_accessible :comments
	attr_accessible :read
	
	belongs_to :user
	belongs_to :course
	belongs_to :assignment_type_flag
	belongs_to :assignment_type
	belongs_to :assignment_flag
	belongs_to :assignment
end