require 'test_helper'

class UsersHomeTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test "home display" do
    # # not logged in
    # get root_url
    # assert_no_match @user.following.count, response.body
    # assert_no_match @user.followers.count, response.body
    # # logged in
    # log_in_as(@user)
    # get root_url
    # assert_match @user.following.count, response.body
    # assert_match @user.followers.count, response.body
  end
end
