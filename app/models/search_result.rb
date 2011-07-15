class SearchResult < ActiveRecord::Base
  belongs_to :search
  validates_uniqueness_of :url
  scope :latest, order('search_results.created_at DESC')
end
