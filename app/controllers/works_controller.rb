class WorksController < ApplicationController
  before_action :find_user_session
  before_action :find_work, only: [:show, :edit, :update]
  before_action :work_not_found, only: [:show, :edit, :destroy]
  
  def index 
    if session[:user_id] != nil
      @works = Work.all
    else
      flash[:error] = "You must be logged in to see this page."
      redirect_to root_path
    end
  end
  
  def show;  end
  
  def new
    @work = Work.new
  end
  
  def create
    @work = Work.new(work_params)
    if @work.save
      redirect_to works_path
      return 
    else 
      render :new
    end
  end
  
  def edit; end
  
  def update
    if @work.update(work_params)
      redirect_to work_path(@work.id)
      return
    else
      render work_path
    end
  end
  
  def destroy    
    @work.destroy
    redirect_to works_path
    return
  end
  
  def vote(work_id)
    if user
      Vote.new(date: Time.now, user_id: session[:user_id], work_id: work_id)
      flash[:success] = "Upvote Counted"
      redirect_to works_path
    else
      flash[:error] = "Must Be Logged in to Vote"
      redirect_to works_path
    end
  end
  
  private
  
  def work_params
    return params.require(:work).permit(:id, :category, :title, :creator, :publication_year, :description)
  end
  
  def find_work
    @work = Work.find_by(id: params[:id])
  end
  
  def work_not_found
    if @work.nil?
      flash[:error] = "Work with ID: #{params[:id]} was not found."
      redirect_to root_path
      return
    end
  end
  
  def find_user_session
    if session[:user_id] == nil
      flash[:error] = "You must be logged in to see this page."
      redirect_to root_path
    end
  end
end
