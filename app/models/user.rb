class User < ApplicationRecord
  has_many :votes
  
  validates :name, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true  
  validates :uid, presence: true, uniqueness: true
  
  #(def self.total_votes)
  def total_votes(user_id)
    upvotes = Vote.where(user_id: user_id)
    return upvotes.count
  end
  
  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.name = auth_hash["info"]["nickname"]
    user.email = auth_hash["info"]["email"]
    user.join_date = Time.now
    return user
  end
  
  
end
