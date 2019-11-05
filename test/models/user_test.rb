require "test_helper"

describe User do
  describe "relations" do
    it "has a list of votes" do
      user = users(:ada)
      user.must_respond_to :votes
      user.votes.each do |vote|
        vote.must_be_kind_of Vote
      end
    end

    it "has a list of ranked works" do
      dan = users(:ada)
      dan.must_respond_to :ranked_works
      dan.ranked_works.each do |work|
        work.must_be_kind_of Work
      end
    end
  end

  describe "validations" do
    it "requires a name" do
      user = users(:ada)
      user.name = nil
      refute(user.valid?)
      user.errors.messages.must_include :name
    end

    it "requires a unique name" do
      user = users(:ada)
      new_user = User.new(name: 'ada759', uid: 1234, email: "ada@com", provider: 'github')
      refute(new_user.valid?)
      new_user.errors.messages.must_include :name
    end

    it "requires a uid number" do
      user = users(:ada)
      user.uid = nil
      refute(user.valid?)
      user.errors.messages.must_include :uid
    end

    it "requires an email" do
      user = users(:ada)
      user.email = nil
      refute(user.valid?)
      user.errors.messages.must_include :email
    end
  end
end
