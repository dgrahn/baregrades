#   File: grade.rb
#  Class: Grade
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class defines a theme. It hooks up the database with
# a CSS class.
# -----------------------------------------------------------

class Theme < ActiveRecord::Base
	attr_accessible :css_class, :name
end