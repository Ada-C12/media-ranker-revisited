require "test_helper"

describe UsersController do
  it "logs in an existing user and redirects to the root route" do
    #Arrange
    start_count = User.count
    user = users(:dan)

    #Act
    # OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    # get auth_callback_path(:github)
    perform_login(user)
    
    #Assert
    must_redirect_to root_path
    session[:user_id].must_equal user.id
    User.count.must_equal start_count
  end

  it "creates a new user when new user logs in" do
    start_count = User.count
    user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com")
  
    perform_login(user)
    must_redirect_to root_path
  
    User.count.must_equal start_count + 1  
    session[:user_id].must_equal User.last.id
  end

  it "redirects to the login route if given invalid user data" do
    start_count = User.count
    user = User.new(provider: "github", uid: nil, name: "test_user2", email: "test2@user.com")
    
    expect{ perform_login(user)}.wont_change "User.count"
    
    must_respond_with :redirect
    must_redirect_to root_path
  end
end