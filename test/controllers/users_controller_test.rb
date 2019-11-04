require "test_helper"

describe UsersController do
let(:dan) { users(:dan) }
  describe 'auth_callback' do
      it "should log in an existing user" do
      # count how many users we have to start with

      start_count = User.count

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(dan))

      get auth_callback_path(:github)

      must_redirect_to root_path
      session[:user_id].must_equal dan.id
      expect(start_count).must_equal User.count
    end

    it "should create a new user" do
      start_count = User.count
      user = User.new(provider: "github", uid: 1234567, email: "nt@adadev.org", name: "natalie")

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(user)
      
      must_redirect_to root_path 
      session[:user_id].must_equal user.uid
      expect(start_count).must_equal (User.count - 1)
    end

    it "should redirect to root_path if passed invalid auth_hash" do
      
    end
  end



  describe 'not-authenticated' do

    describe 'index' do 
      it 'should show a list of valid users' do
        get users_path

        must_respond_with :success
      end
    end

    describe 'show' do 
      it 'should show a valid user' do
        get user_path(dan)

        must_respond_with :success
      end

      it 'should redirect with an invalid user' do
        get user_path(-1)

        must_respond_with :not_found
      end
    end

    describe 'create' do
      it "should create a user with valid data" do
        #mock the callback hash from github
      end

      it "should do x when there is invalid data" do
      end
    end
  
    describe 'destroy' do
      it "should set session[:user_id] to nil upon logout" do
        count = User.all.count
        delete logout_path(dan)

        expect(session[:user_id]).must_be_nil
      end
    end
  end
end
