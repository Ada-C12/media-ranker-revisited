class VotesController < ApplicationController
  before_action :find_user_session
  before_action :find_vote, only: [:show, :edit, :update]
  before_action :vote_not_found, only: [:show, :edit, :destroy]
  
  def index
    @votes = Vote.all
  end
  
  def show; end
  
  def new
    @vote = Vote.new
  end
  
  def create
    
    generated_vote_params = {
      date: Time.now, 
      work_id: params[:work_id],
      user_id: session[:user_id], 
    }
    
    vote_status = Vote.where(work_id: generated_vote_params[:work_id])
    vote_status_check = vote_status.where(user_id: generated_vote_params[:user_id])
    
    if vote_status_check.empty?
      @vote = Vote.new(generated_vote_params)
      
      if @vote.save
        redirect_to works_path
        return
      else
        #Active Record
        #unique check and logged in check, inspect errors and display different flashes dependent on errors.
        flash[:error] = "You have to be Logged in to Vote."
        redirect_to works_path
        return
      end
      
    else
      flash[:error] = "Vote has already been submitted."
      redirect_to root_path
    end
  end
  def edit; end
  
  def update
    if @vote.update(vote_params)
      redirect_to vote_path(@vote.id)
      return
    else
      render user_path
      return
    end
  end
  
  def destroy
    @vote.destroy
    redirect_to votes_path
  end
  
  private
  
  def vote_params
    return params.require(:vote).permit(:id, :work_id, :user_id, :date)
  end
  
  def find_vote
    @vote = Vote.find_by(id: params[:id])
  end
  
  def vote_not_found
    if @vote.nil?
      flash[:error] = "Vote with ID: #{params[:id]} was not found."
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
