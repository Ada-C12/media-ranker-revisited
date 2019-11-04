require "test_helper"

describe UsersController do
  describe "logging in (create)" do 
    it "successfully logs in returning user" do 
      start_count = User.count
      user = users(:grace)

      perform_login(user)
      must_redirect_to root_path
      session[:user_id].must_equal  user.id

      User.count.must_equal start_count
    end 

    it "creates and logs in a new user" do 
      start_count = User.count
      user = User.new(provider: "github", uid: 99999, name: "test_user", email: "test@user.com")

      perform_login(user)
      must_redirect_to root_path

      User.count.must_equal start_count + 1

      session[:user_id].must_equal User.last.id
    end 
  end
  
  describe "logging out (destroy)" do 
    it "logs out user successfully" do 
      user = users(:grace)
      perform_login(user)

      delete logout_path 
      session[:user_id].must_equal nil
      must_redirect_to root_path 
    end 
  end 
end
