#   File: access.rb
#  Class: Access
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class is a utility model for maintaining connections
# between different models. It tells us which users belong to
# which courses and what roles they have.
# -----------------------------------------------------------

class Access < ActiveRecord::Base
	attr_accessible :user_id, :role_id, :course_id
	
	validates :user_id, :presence => true, :numericality => true
	validates :role_id, :presence => true, :numericality => true
	
	validates_uniqueness_of :user_id, :scope => [:course_id]
	
	belongs_to :user
	belongs_to :role
	belongs_to :course
end