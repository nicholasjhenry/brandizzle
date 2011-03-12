class Brand < ActiveRecord::Base
  has_many :searches
  validates_presence_of :name
end
