require "test_helper"

describe User do
  describe "relations" do
    it "has a list of votes" do
      grace = users(:grace)
      grace.must_respond_to :votes
      grace.votes.each do |vote|
        vote.must_be_kind_of Vote
      end
    end
    
    it "has a list of ranked works" do
      grace = users(:grace)
      grace.must_respond_to :ranked_works
      grace.ranked_works.each do |work|
        work.must_be_kind_of Work
      end
    end
  end
  
  describe "validations" do
    it "requires a nickname" do
      user = User.new
      user.valid?.must_equal false
      user.errors.messages.must_include :nickname
    end
    
    it "requires a unique username" do
      nickname = "test username"
      user1 = User.new(nickname: nickname)
      
      # This must go through, so we use create!
      user1.save!
      
      user2 = User.new(nickname: nickname)
      result = user2.save
      result.must_equal false
      user2.errors.messages.must_include :nickname
    end
  end
end
