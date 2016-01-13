require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # def setup gets run before each test.
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
  end
  # Verifies if the user is valid.
  test "should be valid" do
    assert @user.valid?
  end
end
