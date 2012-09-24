class AssignmentType < ActiveRecord::Base
  attr_accessible :description, :name, :worth
  
  validates :name, :presence => true
  validates :worth, :presence => true, :numericality => true
  
  belongs_to :course
  has_many :assignments
end
