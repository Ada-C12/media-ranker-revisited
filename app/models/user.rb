class User < ApplicationRecord
  has_many :votes
  has_many :ranked_works, through: :votes, source: :work
  
  # since there's only 1 OAuth Provider, don't have to worry about clashing uids from diff OAPs
  validates :uid, presence: true
  
  
  
  def self.build_from_github(auth_hash)
    user = User.new
    user.uid = auth_hash[:uid]
    user.provider = "github"
    user.name = auth_hash["info"]["name"]
    user.email = auth_hash["info"]["email"]
    
    # Note that the user has not been saved.
    # We'll choose to do the saving outside of this method
    return user
  end
  
end


# OLD validation
# validates :username, uniqueness: true, presence: true