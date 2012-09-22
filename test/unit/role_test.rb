require 'shoulda'

class RoleTest < ActiveSupport::TestCase
	should validate_presence_of(:name)

	should validate_uniqueness_of(:name)

	should have_many(:accesses)
	should have_many(:users)	
end
