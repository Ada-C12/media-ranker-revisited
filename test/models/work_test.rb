require "test_helper"

describe Work do
  before do
    @user = users(:kennedy)
    @users = users(:kennedy, :gaga)
    
    @work = works(:pill)
    @work2 = works(:kondo)
    @works = works(:pill, :peppers, :dresses, :kondo)
    
    @vote = votes(:pill_vote)
    @votes = votes(:pill_vote, :pill_vote2, :peppers_vote, :dresses_vote)
  end
  
  describe "instantiations" do
    it "can be instantiated" do
      # Assert
      expect(@work.valid?).must_equal true
    end
  end
  
  describe "validations" do
    it "requies title to be instantiated" do
      @work.title = nil
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :title   
    end
    
    it "requies category to be instantiated" do
      @work.category = nil
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :category   
    end
    
    it "requies creator to be instantiated" do
      @work.creator = nil
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :creator   
    end
    
    it "requies publication year to be instantiated" do
      @work.publication_year = nil
      expect(@work.valid?).must_equal false
      expect(@work.errors.messages).must_include :publication_year   
    end
    
    it "requies a unique title to be instantiated" do
      work_2 = Work.new(category: "album", title: "Jagged Little Pill", creator: "Alanis Morisette", publication_year: 1995, description: "test")
      expect(work_2.valid?).must_equal false      
    end
  end
  
  # describe "relations" do
  # end
  
  describe "custom methods" do
    it "totals votes for a work" do
      expect(@work.total_votes).must_equal 2
      expect(@work2.total_votes).must_equal 0
    end
    
    it "sorts the works by category" do
      expect(Work.top_ten("album").count).must_equal 2
      expect((Work.top_ten("album").first)).must_equal works(:pill)
      expect((Work.top_ten("album").last)).must_equal works(:peppers)
    end
    
    it "can find the top votes spotlight work" do
      expect((Work.spotlight)).must_equal works(:pill)
    end
    
  end
end




