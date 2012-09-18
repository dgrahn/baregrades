class Role < ActiveRecord::Base
	attr_accessible :name

	has_many :accesses
	has_many :users, :through => :accesses
end
