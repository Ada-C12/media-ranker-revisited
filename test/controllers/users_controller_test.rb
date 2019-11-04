require "test_helper"

describe UsersController do
  describe 'auth_callback' do
    it 'logs in an existing user and redirects to root' do
      expect { perform_login(users(:dan)) }.wont_change 'User.count'
      expect(session[:user_id]).must_equal users(:dan).id
      must_redirect_to root_path
    end

    it 'logs in a new user and redirects to root' do
      
    end

    it 'redirects to root for invalid callbacks' do
      
    end
  end
end
