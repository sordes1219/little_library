require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_index_url
    assert_response :success
  end
  
  test "should get login_form" do
    get users_login_form_url
    assert_response :success
  end
end
