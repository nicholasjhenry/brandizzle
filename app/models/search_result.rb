class SearchResult < ActiveRecord::Base
  belongs_to :search
  scope :latest, order('search_results.created_at DESC')
end
