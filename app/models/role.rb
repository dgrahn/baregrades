#   File: grade.rb
#  Class: Grade
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds all the information for a role. A role
# defines the permissions which different users have at
# different points in the atmosphere.
# -----------------------------------------------------------

class Role < ActiveRecord::Base
	attr_accessible :name

	has_many :accesses, :dependent => :destroy
	has_many :users, :through => :accesses
	
	validates :name, :presence => true, :uniqueness => true
end
