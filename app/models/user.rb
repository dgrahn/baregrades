class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :last_name, :middle_name, :password, :username

  has_many :accesses
  has_many :courses, :through => :accesses
  has_many :roles, :through => :accesses
end
