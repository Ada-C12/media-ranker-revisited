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

        must_respond_with 404
      end
    end
  end


  describe 'authenticated' do
    describe 'create' do
    end

    describe 'destroy' do
    end
    
  end
end
