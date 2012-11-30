#   File: grade.rb
#  Class: Grade
#   Type: Model
# Author: Dan Grahn, Matt Brooker, Justin Engel
#
# Description:
# This class holds the grade for a single assignment type for
# a single user.
# -----------------------------------------------------------

class User < ActiveRecord::Base
	attr_accessible :email, :first_name, :last_name, :middle_name, :username, :password, :password_confirmation, :theme_id
	attr_accessor :password

	before_save :encrypt_password

	has_many :accesses, :dependent => :destroy
	has_many :courses, :through => :accesses
	has_many :assignments, :through => :courses
	has_many :roles, :through => :accesses, :dependent => :destroy
	belongs_to :theme

	validates :username,	:presence => true,	:uniqueness => true
	validates :password,	:presence => true, :length => {:minimum => 5}, :confirmation => true, :on => "create"
	validates :email, 		:presence => true
	validates :first_name,	:presence => true
	validates :last_name,	:presence => true
	
	# "Login" a user
	def self.authenticate(username, password)
		user = find_by_username(username)
		
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			return user
		else
			return nil
		end
	end
	
	def name
		return "#{first_name} #{last_name}"
	end

	# Encrypt a password
	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt()
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	# Dynamically create is_role? methods
	def method_missing(method_id, *args)
		if match = matches_dynamic_role_check?(method_id)
			tokenize_roles(match.captures.first).each do |check|
				roles.each do |role|
					return true if role.name.downcase == check
				end
			end

			return false
		else
			super
		end
	end
	
	private

	# Helper method to check if the string matches the is_role? type
	def matches_dynamic_role_check?(method_id)
		/^is_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
	end

	# Tokenize strings for is_role_or_role?
	def tokenize_roles(string_to_split)
		string_to_split.split(/_or_/)
	end
end
