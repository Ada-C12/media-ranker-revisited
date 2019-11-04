require "test_helper"

describe VotesController do
  describe "guest user (not authenticated)" do
    it "does not allow voting for unauthenticated user" do
      post vote_path(Work.first.id)
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
  
  describe "authenticated user" do
    before do
      user = users(:oprah)
      OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(mock_auth_hash(user))
      get auth_callback_path
    end
    
    it "allows access when a user is logged in" do
      start_count = Work.first.votes.count
      post vote_path(Work.first.id)
      must_redirect_to works_path
      Work.first.votes.count.must_equal start_count + 1
    end
  end
end
