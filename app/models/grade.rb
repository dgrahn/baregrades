class Grade < ActiveRecord::Base
  attr_accessible :grade
  
  belongs_to :assignment
  belongs_to :user
end
