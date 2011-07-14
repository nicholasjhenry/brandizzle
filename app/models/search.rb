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
    search_results = fetch_twitter_search_results(twitter_client)
    search_results.each { |result| create_result(result) }
    save_latest_id(search_results)
  end

  def save_latest_id(results)
    return unless results.any?

    latest_id = results.sort_by(&:id).last.id
    update_attribute(:latest_id, latest_id)
  end

  private

  def fetch_twitter_search_results(twitter_client)
    twitter_client.
      containing(term).
      tap {|client| client.since_id(latest_id) if latest_id.present? }.
      language('en')
  end 

  def create_result(result)
    results.create(
      :created_at => result.created_at,
      :body       => result.text,
      :source     => "twitter",
      :url        => "http://twitter.com/#{result.from_user}/statuses/#{result.id}")
  end
end
