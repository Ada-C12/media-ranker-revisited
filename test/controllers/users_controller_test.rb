require "test_helper"

describe UsersController do
  describe "index" do 
    it "succeeds when there are users" do 
      get users_path
      must_respond_with :success
    end 

    it "succeeds when there are no users" do
      user1 = users(:dan)
      user2 = users(:kari)
      user1.destroy
      user2.destroy

      get users_path
      must_respond_with :success
    end
  end

  describe "show" do
    it "succeeds" do
      user = users(:dan)
      get user_path(user.id)

      must_respond_with :success
    end
  end

  describe "OAuth" do 
    before do
      perform_login(users(:dan))
    end
    
    describe "create" do 

    end 
  
    describe "log out" do
      it "responds with a redirect when logging out a user" do
        # user = users(:dan)
        # perform_login(user)
        delete logout_path(users(:dan))
        must_respond_with :redirect
        must_redirect_to root_path
  
        expect(session[:user_id]).must_be_nil
        expect(flash[:success]).must_equal "Successfully logged out!"
        # expect(flash[:result_text]).must_equal 
      end
    end

  end

  

  # describe "current" do
  #   it "responds with a not found flash and redirects to root path when id given does not exist" do
  #     get user_path(1)

  #     expect(flash[:error]).must_equal "You must be logged in as an authorized user to access this page."

  #     must_respond_with :redirect
  #     must_redirect_to root_path
  #   end
  # end




end
