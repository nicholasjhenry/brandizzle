class Brand < ActiveRecord::Base
  has_and_belongs_to_many :searches
  validates_presence_of :name

  def add_search(term)
    if search = Search.find_or_create_by_term(term)
      searches << search
    end
  end
end
