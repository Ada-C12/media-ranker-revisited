require "test_helper"

describe UsersController do
  describe 'auth_callback' do
    it 'logs in an existing user and redirects to root' do
      expect { perform_login(users(:dan)) }.wont_change 'User.count'
      expect(session[:user_id]).must_equal users(:dan).id
      must_redirect_to root_path
    end

    it 'logs in a new user and redirects to root' do
      user = User.new(username: "test", uid: 1337, provider: "github")
      expect { perform_login(user) }.must_change "User.count", 1
      expect(session[:user_id]).must_equal User.last.id
      must_redirect_to root_path
    end

    it 'redirects to root for invalid callbacks' do
      expect { perform_login(User.new) }.wont_change "User.count"
      refute session[:user_id]
      must_redirect_to root_path
    end
  end

  describe 'logout' do
    it 'logs out a logged in user and redirects to root' do
      perform_login
      delete logout_path
      refute session[:user_id]
      must_redirect_to root_path
    end

    it 'redirects to root if user isnt logged in' do
      delete logout_path
      refute session[:user_id]
      must_redirect_to root_path
    end
  end
end
