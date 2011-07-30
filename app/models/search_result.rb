class SearchResult < ActiveRecord::Base
  belongs_to :search
  validates_uniqueness_of :url

  class << self
    def latest
      order('search_results.created_at DESC')
    end

    def by_brand(brand_id)
      joins(:search => :brand).where('brands.id' => brand_id)
    end

    def latest_by_brand(brand_id)
      latest.by_brand(brand_id)
    end
  end
end
