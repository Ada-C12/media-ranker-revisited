require "test_helper"

describe UsersController do

  # fixtures :all
#   let(:existing_work) { users(:album) }

  describe "users unauthenticated" do
    it "access all users page without logging in" do
      get users_path
      must_respond_with :redirect
    end

    it "access a single user without logging in" do
      delete logout_path
      get user_path(id: 1)
      must_respond_with :not_found
    end

    describe "users unauthenticated" do
      it "access a single user" do
        expect {
          user = perform_login()
        }.wont_change "User.count"
  
        must_redirect_to root_path
        must_respond_with :success
        expect(session[:user_id]).must_equal user.id

      end
    end

# need to test 

describe  "auth_callback" do 
  it "test an  user and redirect to the root path" do
    user = nil
    expect {
      user = perform_login()
    }.wont_change "User.count"

    must_redirect_to root_path
       # Since we can read the session, check that the user ID was set as expected
    expect(session[:user_id]).must_equal user.id
    # test flash here.............

  end

  it "logs in a new user and redirects them back to the root path" do
    # user = User.new(name:"Chrise", provider: "github", uid: 666, email: "batmail@gmail.com")

    # # Send a login request for that user
    # # Note that we're using the named path for the callback, as defined
    # # in the `as:` clause in `config/routes.rb`
    # expect {
    #   get auth_callback_path(:github)
    # }.must_differ "User.count", 1

    user = perform_login

    must_redirect_to root_path
       # Since we can read the session, check that the user ID was set as expected
    expect(session[:user_id]).must_equal user.id
    # test flash here.............
  end

  it "should redirect back to root for invalid callbacks" do

    OmniAuth.config.mock_auth[:github] = 
    OmniAuth::AuthHash.new(mock_auth_hash(user.new))

    expect {
      get auth_callback_path(:github)
    }.wont_change "User.count"

    must_redirect_to root_path
    expect(session[:user_id]).must_be nil
  end

    

end

# it "logs in an existing user" do
#   start_count = User.count
#   user = users(:grace)

#   perform_login(user)
#   must_redirect_to root_path
#   session[:user_id].must_equal  user.id

#   # Should *not* have created a new user
#   User.count.must_equal start_count
# end































    
  end
end
