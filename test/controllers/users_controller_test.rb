require "test_helper"

describe UsersController do
  describe "index" do
    
    it "responds with success when there is at least one user saved" do
      user = users(:ada)
      
      get users_path
      
      expect(User.count > 0).must_equal true
      must_respond_with :success      
    end
    
    
    # it "responds with success when there are no drivers saved" do
    #   # Act
    #   get drivers_path
    
    #   # Assert
    #   expect(Driver.count).must_equal 0
    #   must_respond_with :success
    # end
  end  
  
  
  describe "login" do
    it "logs in an existing user and redirects to the root route" do
      start_count = User.count  
      user = users(:grace)
      
      perform_login(user)
      
      session[:user_id].must_equal user.id
      must_redirect_to root_path
      User.count.must_equal start_count
    end
    
    it "creates an account for a new user and redirects to the root route" do
      start_count = User.count
      user = User.create(provider: "github", uid: 99999, username: "test_user", email: "test@user.com", name: "Tester")
      
      perform_login(user)
      
      session[:user_id].must_equal User.last.id
      must_redirect_to root_path
      User.count.must_equal start_count + 1
    end
    
    it "redirects to the login route if given invalid user data" do
      start_count = User.count  
      bad_user = User.create(provider: "github", uid: 99999)
      
      perform_login(bad_user)
      
      assert_nil(session[:user_id])
      must_redirect_to root_path
      User.count.must_equal start_count
    end
  end
  
  describe "logout" do
    it "can log out a valid user and redirects to root" do
      start_count = User.count  
      user = users(:ada)
      
      perform_login(user)
      
      delete logout_path
      
      assert_nil(session[:user_id])
      expect(flash[:success]).must_equal "Successfully logged out!"
      must_redirect_to root_path
      User.count.must_equal start_count      
    end
    
    it "redirects to root if you try to log out an invalid user" do
      
    end
    
    
    
    
  end
end






# def create
#   auth_hash = request.env["omniauth.auth"]

#   user = User.find_by(uid: auth_hash[:uid], provider: "github")
#   if user
#     # User was found in the database
#     flash[:success] = "Logged in as returning user #{user.name}"
#   else
#     # User doesn't match anything in the DB
#     # Attempt to create a new user
#     user = User.build_from_github(auth_hash)

#     if user.save
#       flash[:success] = "Logged in as new user #{user.name}"
#     else
#       # Couldn't save the user for some reason. If we
#       # hit this it probably means there's a bug with the
#       # way we've configured GitHub. Our strategy will
#       # be to display error messages to make future
#       # debugging easier.
#       flash[:error] = "Could not create new user account: #{user.errors.messages}"
#       return redirect_to root_path
#     end
#   end

#   # If we get here, we have a valid user instance
#   session[:user_id] = user.id
#   return redirect_to root_path
# end

# def show
#   @user = User.find_by(id: params[:id])
#   render_404 unless @user
# end



