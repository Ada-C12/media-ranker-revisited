require "test_helper"

describe UsersController do
  let(:existing_user) { users(:kari) }
  
  describe "auth_callback (create)" do
    it "logs in a new user and redirects them back to the root path" do
      user = User.new(
        uid: "111111",
        email: "eaball35@gmail.com",
        provider: "github",
        username: "eaball35",
        name: "Emily"
      )

      expect {
        perform_login(user)
      }.must_change "User.count", 1

      user = User.find_by(uid: user.uid)

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Logged in as new user #{user.name}", flash[:success]
    end

    it "logs in an existing user and redirects them to the root path" do
      user = users(:dan)

      expect{
        perform_login(user)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_equal user.id
      assert_equal "Logged in as returning user #{user.name}", flash[:success]
    end

    
    it "redirects back to the root path for invalid callbacks" do
      expect {
        perform_login(User.new)
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
    end
  end

  describe "loggout (destroy)" do
    it "successfully logs out a logged in user" do
      user = users(:dan)
      perform_login(user)

      expect {
        delete logout_path
      }.wont_change "User.count"

      must_redirect_to root_path
      expect(session[:user_id]).must_be_nil
      assert_equal "Successfully logged out!", flash[:success]
    end

    it "logging out nonexistant user won't change anything" do 
      perform_login(User.new)
      
      expect { 
        delete logout_path
      }.wont_change "User.count"

      expect(session[:user_id]).must_be_nil
      refute_equal "Successfully logged out!", flash[:success]
    end 
  end


  describe "index" do
    describe 'logged out' do
      it 'responds with redirect and error message if not logged in' do
        delete logout_path
        expect(session[:user_id]).must_be_nil
        
        get users_path

        assert_equal :failure, flash[:status]
        assert_equal "You must be logged in to do that.", flash[:result_text]
        must_redirect_to root_path
      end
    end
    
    describe 'logged in' do
      before do
        perform_login(users(:dan))
      end
      
      it "succeeds when there are users" do
        get works_path

        must_respond_with :success
      end

      it "succeeds when there are no users" do
        User.destroy_all
        perform_login(users(:dan))
        
        get users_path

        must_respond_with :success
      end
    end
  end

  describe "show" do
    describe 'logged out' do
      it 'responds with redirect and error message if not logged in' do
        delete logout_path
        expect(session[:user_id]).must_be_nil
        
        get user_path(existing_user.id)

        assert_equal :failure, flash[:status]
        assert_equal "You must be logged in to do that.", flash[:result_text]
        must_redirect_to root_path
      end
    end
    
    describe 'logged in' do
      before do
        perform_login(users(:dan))
      end
      it "succeeds for an existing user ID" do
        get user_path(existing_user.id)

        must_respond_with :success
      end

      it "renders 404 not_found for a bogus user ID" do
        destroyed_id = existing_user.id
        existing_user.destroy

        get user_path(destroyed_id)

        must_respond_with :not_found
      end
    end
  end
end
