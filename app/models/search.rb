class Search < ActiveRecord::Base
  belongs_to :brand
  validates_presence_of :term
  has_many :results, :class_name => "SearchResult"

  class << self
    def run_against_twitter(twitter_client=Twitter::Search.new)
      all.each { |search| search.run_against_twitter(twitter_client) }
    end
  end

  def run_against_twitter(twitter_client)
    twitter_search_results = twitter_client.containing(term).language('en')
    twitter_search_results.each do |result|
      results.create(
        :created_at => result.created_at,
        :body       => result.text,
        :source     => "twitter",
        :url        => "http://twitter.com/#{result.from_user}/statuses/#{result.id}")
    end
  end
end
