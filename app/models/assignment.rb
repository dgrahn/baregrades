class Assignment < ActiveRecord::Base
  attr_accessible :description, :name, :worth
  
  validates :name, :presence => true
  validates :worth, :presence => true
  
  has_many :grades
end
