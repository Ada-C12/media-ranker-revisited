require "test_helper"

describe Vote do
  describe "relations" do
    it "has a user" do
      v = votes(:one)
      v.must_respond_to :user
      v.user.must_be_kind_of User
    end

    it "has a work" do
      v = votes(:one)
      v.must_respond_to :work
      v.work.must_be_kind_of Work
    end
  end

  describe "validations" do
    let (:user1) { users(:ada) }
    let (:user2) { users(:betsy)}
    let (:work1) { works(:album) }
    let (:work2) { works(:another_album)}

    it "allows one user to vote for multiple works" do
      vote1 = Vote.new(user: user1, work: work1)
      vote1.save
      vote2 = Vote.new(user: user1, work: work2)
      vote2.save.must_equal true
    end

    it "allows multiple users to vote for a work" do
      vote1 = Vote.new(user: user1, work: work1)
      vote1.save
      vote2 = Vote.new(user: user2, work: work1)
      vote2.save.must_equal true
    end

    it "doesn't allow the same user to vote for the same work twice" do
      vote1 = Vote.new(user: user1, work: work1)
      vote1.save
      vote2 = Vote.new(user: user1, work: work1)
      vote2.save.must_equal false
      vote2.errors.messages.must_include :user
    end
  end
end
