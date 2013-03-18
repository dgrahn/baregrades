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
	attr_accessible :email
	attr_accessible :email_confirmation
	attr_accessible :first_name
	attr_accessible :last_name
	attr_accessible :middle_name
	attr_accessible :username
	attr_accessible :password
	attr_accessible :password_confirmation
	attr_accessible :theme_id
	attr_accessible :reputation
	
	attr_accessor :password

	before_save :encrypt_password

	has_many :grades, 									:dependent => :destroy
	has_many :notifications,							:dependent => :destroy
	has_many :accesses, 								:dependent => :destroy
	has_many :roles, 		:through => :accesses, 		:dependent => :destroy
	has_many :courses, 		:through => :accesses
	has_many :assignments, 	:through => :courses

	has_many :assignment_flags, :dependent => :destroy
	has_many :assignment_type_flags, :dependent => :destroy
	belongs_to :theme

	validates :username,	:presence => true, :uniqueness => true
	validates :password,	:presence => true, :length => {:minimum => 5}, :confirmation => true, :on => :create
	validates :email, 		:presence => true, :uniqueness => true, :confirmation => true, :on => :create
	validates :first_name,	:presence => true
	validates :last_name,	:presence => true
	
	# "Login" a user
	# @param username [String]
	# @param password [String]
	# @return [User]
	def self.authenticate(username, password)
		user = find_by_username(username)
		
		if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
			return user
		else
			return nil
		end
	end
	
	# Get full name in one stroke
	def name
		"#{first_name} #{last_name}"
	end

	# Add points to the reputation, positive or negative
	# @param points [integer]
	def add_reputation(points)
		if self.reputation 
			self.reputation += points
		else
			self.reputation = points
		end

		self.save
	end
	
	# @return [boolean] User has unread notifications.
	def has_notifications?()
		return (0 < self.notifications.where(read: false).count)
	end

	# Encrypt a password
	def encrypt_password
		if password.present?
			self.password_salt = BCrypt::Engine.generate_salt()
			self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
		end
	end

	# Dynamically create is_role? methods
	# @param methodid [integer]
	# @return [boolean]
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
	# @param methodid [integer]
	def matches_dynamic_role_check?(method_id)
		/^is_([a-zA-Z]\w*)\?$/.match(method_id.to_s)
	end

	# Tokenize strings for is_role_or_role?
	# @param methodid [String]
	def tokenize_roles(string_to_split)
		string_to_split.split(/_or_/)
	end
end