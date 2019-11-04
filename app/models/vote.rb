class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :work
  validates :user_id, presence: true;
  validates :work_id, presence: true;
  #check ActiveRecord composite unique across two fields
  
end
