require 'test_helper'
require 'shoulda'

class AssignmentTest < ActiveSupport::TestCase
	should validate_presence_of(:name)
	should validate_presence_of(:worth)

	should belong_to(:assignment_type)
	should have_many(:grades)

	should validate_numericality_of(:worth)
end