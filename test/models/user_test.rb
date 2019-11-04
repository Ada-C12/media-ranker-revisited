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
      user = User.new
      user.valid?.must_equal false
      user.errors.messages.must_include :username
    end

    it "requires a unique username" do
      username = "test username"
      user1 = User.new(username: username)

      # This must go through, so we use create!
      user1.save!

      user2 = User.new(username: username)
      result = user2.save
      result.must_equal false
      user2.errors.messages.must_include :username
    end
  end

  describe "build from github" do
    it "can build an auth_hash from github" do
      auth_hash = { 
        uid: 12300,
        info: {
          email: "random@email.com",
          name: "random"
        }
      }
      
      new_user = User.build_from_github(auth_hash)
      
      expect(new_user).must_be_kind_of User
      
      expect(new_user.uid).must_equal auth_hash[:uid]
      expect(new_user.email).must_equal auth_hash[:info][:email]
      expect(new_user.username).must_equal auth_hash[:info][:name]
    end
  end
end
