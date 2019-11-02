require "test_helper"

describe UsersController do
  
  before do
    @user = User.create(username: "testy_mctesterson", email: "test@test.com", provider: "Github", uid: 1234)
  end
  
  describe "while not logged in" do
    
    describe "index" do
      it "can get the index path" do
        get users_path
        
        must_respond_with :success
      end
    end

    describe "show" do
      it "can get a valid user" do
        get user_path(@user.id)
        
        must_respond_with :success
      end
      
      it "will redirect for an invalid user" do
        get user_path(-1)
        
        must_respond_with :not_found
      end
    end
    
  end
  
end

