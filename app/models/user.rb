class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :middle_name, :password, :username

  has_many :access
  has_many :courses, :through => :access
  has_many :roles, :through => :access
end
