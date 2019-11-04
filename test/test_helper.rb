ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/skip_dsl"
require "minitest/reporters" 
require 'minitest/autorun'

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

class ActiveSupport::TestCase

  fixtures :all

  def setup
    OmniAuth.config.test_mode = true
  end
  
  def mock_auth_hash(user)
    return {
      provider: "github",
      uid: user.uid,
      info: {
        email: user.email,
        name: user.username
      }
    }
  end

  def perform_login(user = nil)
    user ||= User.first
    
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))

    get auth_callback_path
    
    return user
  end
end
