require "test_helper"

describe WorksController do
  describe "guest user (not authenticated)" do
    it "redirects to root path when user is not logged in" do
      get works_path
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
      
      get new_work_path
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
      
      get edit_work_path(Work.first.id)
      expect(flash[:error]).must_equal "You must be logged in to see this page."
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end
  
  describe "authenticated user" do
    before do
      user = users(:kennedy)
      perform_login(user)
    end
    
    it "allows access when a user is logged in" do
      get works_path
      must_respond_with :success
      
      get new_work_path
      must_respond_with :success
      
      get edit_work_path(Work.first.id)
      must_respond_with :success
    end
  end
end
