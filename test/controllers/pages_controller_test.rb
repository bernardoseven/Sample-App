require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Should get home" do
    get :home
    assert_response :success # Is a representation of a 200 http ok response
    assert_select "title", "Home" # Verifies the title is equal to "Home"
  end
end
