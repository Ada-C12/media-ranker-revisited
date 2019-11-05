require "test_helper"

describe WorksController do
  let(:existing_work) { works(:album) }
  
  describe "guest user" do  
    describe "root" do
      it "succeeds with all media types" do
        get root_path

        must_respond_with :success
      end

      it "succeeds with one media type absent" do
        only_book = works(:poodr)
        only_book.destroy

        get root_path

        must_respond_with :success
      end

      it "succeeds with no media" do
        Work.all do |work|
          work.destroy
        end

        get root_path

        must_respond_with :success
      end
    end

    CATEGORIES = %w(albums books movies)
    INVALID_CATEGORIES = ["nope", "42", "", "  ", "albumstrailingtext"]

    describe "index" do
      it "cannot access the works index" do
        get works_path

        expect(flash[:error]).must_equal "You must be logged in to view this section"
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "new" do
      it "succeeds" do
        get new_work_path

        must_respond_with :success
      end
    end

    describe "create" do
      it "creates a work with valid data for a real category" do
        new_work = { work: { title: "Dirty Computer", category: "album" } }

        expect {
          post works_path, params: new_work
        }.must_change "Work.count", 1

        new_work_id = Work.find_by(title: "Dirty Computer").id

        must_respond_with :redirect
        must_redirect_to work_path(new_work_id)
      end

      it "renders bad_request and does not update the DB for bogus data" do
        bad_work = { work: { title: nil, category: "book" } }

        expect {
          post works_path, params: bad_work
        }.wont_change "Work.count"

        must_respond_with :bad_request
      end

      it "renders 400 bad_request for bogus categories" do
        INVALID_CATEGORIES.each do |category|
          invalid_work = { work: { title: "Invalid Work", category: category } }

          proc { post works_path, params: invalid_work }.wont_change "Work.count"

          Work.find_by(title: "Invalid Work", category: category).must_be_nil
          must_respond_with :bad_request
        end
      end
    end

    describe "show" do
      it "cannot access the show page for a work" do
        get work_path(existing_work.id)

        expect(flash[:error]).must_equal "You must be logged in to view this section"
        must_respond_with :redirect
        must_redirect_to root_path
      end
    end

    describe "edit" do
      it "succeeds for an extant work ID" do
        get edit_work_path(existing_work.id)

        must_respond_with :success
      end

      it "renders 404 not_found for a bogus work ID" do
        bogus_id = existing_work.id
        existing_work.destroy

        get edit_work_path(bogus_id)

        must_respond_with :not_found
      end
    end

    describe "update" do
      it "succeeds for valid data and an extant work ID" do
        updates = { work: { title: "Dirty Computer" } }

        expect {
          put work_path(existing_work), params: updates
        }.wont_change "Work.count"
        updated_work = Work.find_by(id: existing_work.id)

        updated_work.title.must_equal "Dirty Computer"
        must_respond_with :redirect
        must_redirect_to work_path(existing_work.id)
      end

      it "renders bad_request for bogus data" do
        updates = { work: { title: nil } }

        expect {
          put work_path(existing_work), params: updates
        }.wont_change "Work.count"

        work = Work.find_by(id: existing_work.id)

        must_respond_with :not_found
      end

      it "renders 404 not_found for a bogus work ID" do
        bogus_id = existing_work.id
        existing_work.destroy

        put work_path(bogus_id), params: { work: { title: "Test Title" } }

        must_respond_with :not_found
      end
    end

    describe "destroy" do
      it "succeeds for an extant work ID" do
        expect {
          delete work_path(existing_work.id)
        }.must_change "Work.count", -1

        must_respond_with :redirect
        must_redirect_to root_path
      end

      it "renders 404 not_found and does not update the DB for a bogus work ID" do
        bogus_id = existing_work.id
        existing_work.destroy

        expect {
          delete work_path(bogus_id)
        }.wont_change "Work.count"

        must_respond_with :not_found
      end
    end

    describe "upvote" do
      it "redirects to the work page if no user is logged in" do
        new_work = works(:album)
    
        post upvote_path(new_work)

        must_respond_with :redirect
        must_redirect_to work_path(new_work.id)       
      end

      it "doesn't increase vote count when unlogged user tries to vote" do
        new_work = works(:album)
        delete logout_path
    
        expect { post upvote_path(new_work) }.wont_change "new_work.votes.count"

        expect(new_work.votes.count).must_equal 2
      end

      it "shows failure message if unlogged user tries to vote" do
        new_work = works(:album)
      
        post upvote_path(new_work)
        
        expect(flash[:result_text]).must_equal "You must log in to do that"
        expect(flash[:status]).must_equal :failure
      end

      it "redirects to the work page after the user has logged out" do
        new_work = works(:movie)
        user = users(:kari)
        perform_login(user)
        delete logout_path

        expect { post upvote_path(new_work) }.wont_change "new_work.votes.count"

        expect(flash[:result_text]).must_equal "You must log in to do that"
        expect(flash[:status]).must_equal :failure
      end
    end
  end

  describe "logged" do
    describe "index" do
      it "succeeds when there are works" do
        user = users(:kari)
        perform_login(user)
        
        get works_path

        must_respond_with :success
      end

      it "succeeds when there are no works" do
        user = users(:kari)
        perform_login(user)

        Work.all do |work|
          work.destroy
        end

        get works_path

        must_respond_with :success
      end
    end

    describe "upvote" do
      it "succeeds for a logged-in user and a fresh user-vote pair" do
        new_work = works(:movie)
        user = users(:kari)
        perform_login(user)
    
        expect { post upvote_path(new_work) }.must_change "new_work.votes.count", +1

        must_redirect_to work_path(new_work)
        expect(flash[:result_text]).must_equal "Successfully upvoted!"
        expect(flash[:status]).must_equal :success
      end

      it "redirects to the work page if the user has already voted for that work" do
        new_work = works(:album)
        user = users(:kari)
        perform_login(user)
    
        expect { post upvote_path(new_work) }.wont_change "new_work.votes.count"

        must_redirect_to work_path(new_work)
        expect(flash[:result_text]).must_equal "Could not upvote"
        expect(flash[:status]).must_equal :failure
        expect(new_work.votes.count).must_equal 2
      end

      it "cannot vote for an invalid work" do
      
        invalid_work = -1
        user = users(:kari)
        perform_login(user)
    
        post upvote_path(invalid_work)

        must_respond_with :not_found
      end
    end

    describe "show" do
      it "succeeds for an extant work ID" do
        user = users(:dan)
        perform_login(user)

        get work_path(existing_work.id)

        must_respond_with :success
      end

      it "renders 404 not_found for a bogus work ID" do
        user = users(:dan)
        perform_login(user)
        
        destroyed_id = existing_work.id
        existing_work.destroy

        get work_path(destroyed_id)

        must_respond_with :not_found
      end
    end
  end
end

