require 'test_helper'

class GradeScalesControllerTest < ActionController::TestCase
  setup do
    @grade_scale = grade_scales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grade_scales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade_scale" do
    assert_difference('GradeScale.count') do
      post :create, grade_scale: { a: @grade_scale.a, a_minus: @grade_scale.a_minus, a_plus: @grade_scale.a_plus, b: @grade_scale.b, b_minus: @grade_scale.b_minus, b_plus: @grade_scale.b_plus, c: @grade_scale.c, c_minus: @grade_scale.c_minus, c_plus: @grade_scale.c_plus, course_id: @grade_scale.course_id, d: @grade_scale.d, d_minus: @grade_scale.d_minus, d_plus: @grade_scale.d_plus, f: @grade_scale.f, f_minus: @grade_scale.f_minus, f_plus: @grade_scale.f_plus }
    end

    assert_redirected_to grade_scale_path(assigns(:grade_scale))
  end

  test "should show grade_scale" do
    get :show, id: @grade_scale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grade_scale
    assert_response :success
  end

  test "should update grade_scale" do
    put :update, id: @grade_scale, grade_scale: { a: @grade_scale.a, a_minus: @grade_scale.a_minus, a_plus: @grade_scale.a_plus, b: @grade_scale.b, b_minus: @grade_scale.b_minus, b_plus: @grade_scale.b_plus, c: @grade_scale.c, c_minus: @grade_scale.c_minus, c_plus: @grade_scale.c_plus, course_id: @grade_scale.course_id, d: @grade_scale.d, d_minus: @grade_scale.d_minus, d_plus: @grade_scale.d_plus, f: @grade_scale.f, f_minus: @grade_scale.f_minus, f_plus: @grade_scale.f_plus }
    assert_redirected_to grade_scale_path(assigns(:grade_scale))
  end

  test "should destroy grade_scale" do
    assert_difference('GradeScale.count', -1) do
      delete :destroy, id: @grade_scale
    end

    assert_redirected_to grade_scales_path
  end
end
