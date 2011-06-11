class Search < ActiveRecord::Base
  belongs_to :brand
  validates_presence_of :term
  has_many :results, :class_name => "SearchResult"

  class << self
    def run_against_twitter(twitter_client=Twitter::Search.new)
      searches = self.all
      searches.each do |search|
        results = twitter_client.containing(search.term).language('en')
        results.each do |result|
          search.results.create(
            created_at: result.created_at,
            body: result.text,
            source: "twitter",
            url: "http://twitter.com/#{result.from_user}/statuses/#{result.id}")
        end
      end
    end
  end
end
