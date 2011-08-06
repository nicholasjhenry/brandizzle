require 'core_extensions/hash'

class SearchResult < ActiveRecord::Base
  belongs_to :search
  validates_uniqueness_of :url

  class << self
    def latest(params=nil)
      search(convert_to_search_params(params)).order('search_results.created_at DESC')
    end

    private

    # Converts the params to match the implement of MetaSearch. Coerces the params hash
    # into HasWithIndifferentAccess so there are no problems keys being strings or hashes
    def convert_to_search_params(params)
      HashWithIndifferentAccess.new(params).rewrite(
        :brand_id => :search_brands_id_equals,
        :source   => :source_equals
      )
    end
  end
end
