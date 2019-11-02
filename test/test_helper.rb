ENV["RAILS_ENV"] = "test"
require File.expand_path("../../config/environment", __FILE__)
require "rails/test_help"
require "minitest/rails"
require "minitest/skip_dsl"
require "minitest/reporters"  

Minitest::Reporters.use!(
  Minitest::Reporters::SpecReporter.new,
  ENV,
  Minitest.backtrace_filter
)

require "minitest/rails/capybara"
require "minitest/pride"

class ActiveSupport::TestCase
  fixtures :all

  def setup
    OmniAuth.config.test_mode = true
  end

  def mock_auth_hash(user)
    return {
             provider: user.provider,
             uid: user.uid,
             info: {
               email: user.email,
               nickname: user.name,
             },
             extra: {
               raw_info: {
                 login: user.username
               },
             },
           }
  end

  def perform_login(user = nil)
    user ||= User.first
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
    get auth_callback_path(:github)
    return user
  end
end
