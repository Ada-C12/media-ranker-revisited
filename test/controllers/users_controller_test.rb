require "test_helper"
require "pry"
describe UsersController do
let(:dan) { users(:dan) }
let(:natalie ) { User.new(username: "natalietapias", provider: "github",  name: "natalie", email: "nt@adadev.org", uid: 12345678) }
      

  describe 'auth_callback' do
    it "should log in an existing user" do
      start_count = User.count
      perform_login(dan)

      must_redirect_to root_path
      session[:uid].must_equal dan.uid
      expect(start_count).must_equal User.count
    end
      
    it "should create a new user" do
      start_count = User.count
    
      perform_login(natalie)
      
      expect(User.count).must_equal start_count + 1
     

      # must_redirect_to root_path 
      # expect(User.count).must_equal (start_count + 1)
    end

    it "should flash error and redirect to root path if invalid user info provided" do
      start_count = User.count
      ted = User.new(provider: "github", name: "ted")
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(ted))
      get auth_callback_path(:github)

      
      must_redirect_to root_path
      expect(flash[:error]).wont_be_nil
      expect(flash[:uid]).must_be_nil
      expect(start_count).must_equal User.count
    end

    describe "logout" do
      it "should successfully log out a user" do
        # log in 
        OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(dan))

        get auth_callback_path(:github)
        must_redirect_to root_path
        session[:uid].must_equal dan.uid

        # log out
        delete logout_path
        expect(session[:uid]).must_be_nil
        expect(flash[:success]).wont_be_nil
        must_redirect_to root_path

      end
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
  end
end
