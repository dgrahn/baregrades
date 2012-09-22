require 'shoulda'

class UserTest < ActiveSupport::TestCase
	should validate_presence_of(:username)
	should validate_presence_of(:password)
	should validate_presence_of(:email)
	should validate_presence_of(:first_name)
	should validate_presence_of(:last_name)

	should validate_uniqueness_of(:username)

	should ensure_length_of(:password).is_at_least(5)

	should have_many(:accesses)
	should have_many(:courses)
	should have_many(:roles)
	should have_many(:grades)
end