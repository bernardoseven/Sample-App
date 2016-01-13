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
  
  test "should be present" do
    @user.name = " " # assign an empty string.
    assert_not @user.valid? # this ensures that a blank string is not valid.
  end
  # Equal to the above test.
  test "should do something" do
    @user.email = " "
    assert_not @user.valid?
  end
  # ensures length name be <= 50 characters.
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end
  # ensures length email be database length compatible.
  test "email should not be too long" do
    @user.email = "a" * 256
    assert_not @user.valid?
  end
end
