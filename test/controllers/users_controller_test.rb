require "test_helper"
require "pry"

describe UsersController do
  describe "Login" do
    let(:fakeperson) { users(:fakeperson) }

    it "logs a user in" do
      start_count = User.count

      test_user = users(:fakeperson)

      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(test_user))

      get auth_callback_path(:github)

      must_redirect_to root_path

      expect(flash[:success]).must_equal "Logged in as returning user #{test_user.name}"

      expect(session[:user_id]).must_equal test_user.id

      expect(User.count).must_equal start_count
    end
  end

  it "creates an account for a new user and redirects to the root route" do
    start_count_before = User.count

    new_user = User.create(username: "adastudent", name: "programmer", email: "nobody@nobody.com", uid: 13573, provider: "github")

    perform_login(new_user)

    must_redirect_to root_path

    expect(flash[:success]).must_equal "Logged in as returning user #{new_user.name}"

    db_new_user = User.find_by(id: new_user.id)
    expect(session[:user_id]).must_equal db_new_user.id
   
    assert(User.count == start_count_before + 1)
  end

  describe "LOGOUT/Destroy" do
    it "valid user can logout correctly" do
     
      new_user = User.create(username: "adastudent", name: "programmer", email: "nobody@nobody.com", uid: 13573, provider: "github")
  
      perform_login(new_user)
  
      must_redirect_to root_path
      
      delete logout_path
      
      refute(session[:user_id])
      assert(flash[:success] == "Successfully logged out!")
      must_redirect_to root_path
    end
    
    it "non-logged-in person cannot logout" do
      get root_path
      refute(session[:user_id])
      expect(session[:user_id]).must_be_nil
      
      delete logout_path
      
      # should see before_action's require_login kick in with error msg & redirect
      assert(flash[:error] == "You must be logged in to view this section")
      must_redirect_to root_path
    end
  end
end





