require "test_helper"
require "pry"

describe Vote do
  before do
    @user = users(:kennedy)
    @users = users(:kennedy, :gaga)
    
    @work = works(:pill)
    @work2 = works(:kondo)
    @works = works(:pill, :peppers, :dresses, :kondo)
    
    @vote = votes(:pill_vote)
    @votes = votes(:pill_vote, :pill_vote2, :peppers_vote, :dresses_vote)
    #binding.pry
  end
  
  describe "instantiations" do
    it "can be instantiated" do
      # Assert
      expect(@vote.valid?).must_equal true
    end
  end
  
  describe "validations" do
    it "requies work_id to be instantiated" do
      @vote.work_id = nil
      expect(@vote.valid?).must_equal false
      expect(@vote.errors.messages).must_include :work_id   
    end
    
    it "requies user_id to be instantiated" do
      @vote.user_id = nil
      expect(@vote.valid?).must_equal false
      expect(@vote.errors.messages).must_include :user_id   
    end
  end
  
  describe "relations" do
    it "can relate work_id and user_id to vote" do
      expect(@vote.work).must_be_instance_of Work
      expect(@vote.work_id).must_equal @work.id
      expect(@vote.user_id).must_equal @user.id
      
      user = User.create!(name: "Tom Brady", email: "Test@gmail.com", uid: 98767, join_date: Time.now)
      work = Work.create!(category: "book", title: "Where the Sidewalk Ends", creator: "Shel Silverstein", publication_year: 1992)
      vote = Vote.create!(work_id: work.id, user_id: user.id, date: Time.now)
      
      expect(vote.work_id).must_equal work.id
      expect(vote.user_id).must_equal user.id
      
      expect(vote.work).must_equal work
      expect(vote.user).must_equal user
    end
  end
  
end
