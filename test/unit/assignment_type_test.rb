require 'test_helper'
require 'shoulda'

class AssignmentTypeTest < ActiveSupport::TestCase
	should validate_presence_of(:name)
	should validate_presence_of(:worth)
	
	should validate_numericality_of(:worth)
	
	should belong_to(:course)
	should have_many(:assignments)
end
