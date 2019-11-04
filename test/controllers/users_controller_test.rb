require "test_helper"

describe UsersController do
  let(:dan) {users(:dan)}
  describe "Login" do

  #start_count = User.count

  user = users(:dan)

  OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

  get auth_callback_path(:github)

  must_redirect_to root_path
  expect(flash[:success]).must_equal "Logged in as returning user #{user.name}"

  expect(session[:user_id]).must_equal user.id

 # assert(User.count == start_count_before)
  end
end
# Read about fixtures at http://api.rubyonrails.org/classes/ActiveRecord/FixtureSet.html