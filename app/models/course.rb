class Course < ActiveRecord::Base
  attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed
  
  has_one :grade_scale
  has_many :access
  has_many :users, :through => :access
end