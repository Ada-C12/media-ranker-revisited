require "test_helper"

describe User do
  describe "relations" do
    it "has a list of votes" do
      dan = users(:dan)
      dan.must_respond_to :votes
      dan.votes.each do |vote|
        vote.must_be_kind_of Vote
      end
    end
    
    it "has a list of ranked works" do
      dan = users(:dan)
      dan.must_respond_to :ranked_works
      dan.ranked_works.each do |work|
        work.must_be_kind_of Work
      end
    end
  end
  
  describe "validations" do
    it "requires a username" do
      user = User.new(username: "user test", uid: 9999)
      user.valid?.must_equal true
    end
    
    it "requires a unique uid" do
      username = "test uid"
      user1 = User.new(username: username, uid: 1111111)
      
      # This must go through, so we use create!
      user1.save!
      
      user2 = User.new(username: username, uid:1111111)
      result = user2.save
      result.must_equal false
      user2.errors.messages.must_include :uid
    end
  end
end
