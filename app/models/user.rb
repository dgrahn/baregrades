class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :middle_name, :password, :username

  has_many :accesses
  has_many :courses, :through => :accesses
  has_many :roles, :through => :accesses
  has_many :grades

  validates :username, 		:presence => true,	:uniqueness => true
  validates :password, 		:presence => true,	:length => {:minimum => 5}
  validates :email, 		:presence => true
  validates :first_name, 	:presence => true
  validates :last_name,		:presence => true
end
