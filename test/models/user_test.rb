require "test_helper"

describe User do
  before do
    @user = users(:kennedy)
    @user2 = users(:oprah)
    @work = works(:pill)
    @vote = votes(:pill_vote)
  end
  
  describe "instantiations" do
    it "can be instantiated" do
      # Assert
      expect(@user.valid?).must_equal true
    end
    
    it "will have the required fields" do
      [:name, :uid, :email, :join_date, :provider].each do |field|
        expect(@user).must_respond_to field
      end
    end
  end
  
  describe "validations" do
    it "requies name to be instantiated" do
      @user.name = nil
      expect(@user.valid?).must_equal false
      expect(@user.errors.messages).must_include :name    
    end
    
    it "requies a unique name to be instantiated" do
      user_2 = User.new(name: "Katie Kennedy", join_date: Time.now)
      expect(user_2.valid?).must_equal false      
    end
  end
  
  describe "relations" do
    
  end
  
  describe "custom methods" do
    it "returns total upvotes contributed by user" do
      expect(@user.total_votes(@user)).must_equal 2
      expect(@user2.total_votes(@user2.id)).must_equal 0
    end
  end
end

