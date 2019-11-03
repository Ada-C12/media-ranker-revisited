require "test_helper"

describe UsersController do
let(:dan) { users(:dan) }
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
