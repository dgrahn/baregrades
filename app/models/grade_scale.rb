class GradeScale < ActiveRecord::Base
  attr_accessible :a, :a_minus, :a_plus, :b, :b_minus, :b_plus, :c, :c_minus, :c_plus, :course_id, :d, :d_minus, :d_plus, :f, :f_minus, :f_plus
end
