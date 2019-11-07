class Work < ApplicationRecord
  has_many :votes
  
  validates :category, presence: true;
  validates :title, presence: true, uniqueness: true
  validates :creator, presence: true
  validates :publication_year, presence: true #, numericality: { with: /\A\d{4}\z/, message: "Please Enter 4 Digit Year" }
  
  def total_votes
    upvotes = Vote.where(work_id: self.id)
    return upvotes.count
  end
  
  def self.top_ten(category)
    works_to_sort = Work.where(category: category)
    top_ten = works_to_sort.sort_by{ |work| -work.total_votes}
    if top_ten.count < 10
      list_count = top_ten.count
    elsif top_ten.count == 0
      return nil
    else
      list_count = 10
    end
    return top_ten.slice(0..list_count)
  end
  
  def self.spotlight 
    works = Work.all
    most_frequent_item = works.max_by{ |work| work.total_votes}
    return most_frequent_item
  end
  
  
  
  
  # def self.spotlight
  #   vote_count = {}
  #   @works.each do |work|
  #     vote_count[:work.title] => total_votes(work.id)
  #   end)
  #   top_work = hash.key(hash.values.max)
  #   return top_work
  # end
end
