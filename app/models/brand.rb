class Brand < ActiveRecord::Base
  has_and_belongs_to_many :searches
  validates_presence_of :name

  def add_search(term)
    if search = Search.find_or_create_by_term(term)
      searches << search
    end
    search
  end
  
  def remove_search(search)
    if searches.include?(search)
      searches.delete(search)
      search.destroy if search.brands.count == 0
    end
  end
end
