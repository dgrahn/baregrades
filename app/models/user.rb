class User < ActiveRecord::Base
	attr_accessible :email, :first_name, :last_name, :middle_name, :username, :password, :password_confirmation
	attr_accessor :password

	before_save :encrypt_password

	has_many :accesses
	has_many :courses, :through => :accesses
	has_many :roles, :through => :accesses
	has_many :grades

	validates :username,	:presence => true,	:uniqueness => true
	validates :password,	:presence => true,	:length => {:minimum => 5}, :confirmation => true
	validates :email, 		:presence => true
	validates :first_name,	:presence => true
	validates :last_name,	:presence => true

	def self.authenticate(username, password)
		user = find_by_username(username)
		
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			return user
		else
			return nil
		end
	end

	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt()
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end
end
