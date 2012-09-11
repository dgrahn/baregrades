class Course < ActiveRecord::Base
  attr_accessible :credits, :description, :identifier, :name, :pin, :points_based, :section, :student_managed
end
