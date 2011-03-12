class Search < ActiveRecord::Base
  belongs_to :brand
  validates_presence_of :term
end
