require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest
  test "should get index_rent" do
    get books_index_rent_url
    assert_response :success
  end

end
