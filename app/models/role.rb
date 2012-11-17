class Role < ActiveRecord::Base
	attr_accessible :name

	has_many :accesses, :dependent => :destroy
	has_many :users, :through => :accesses
	
	validates :name, :presence => true, :uniqueness => true
end
