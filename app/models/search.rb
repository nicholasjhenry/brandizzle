require 'google_blog/search'

class Search < ActiveRecord::Base
  has_and_belongs_to_many :brands
  validates_presence_of :term
  has_many :results, :class_name => "SearchResult"

  class << self
    def run(twitter_client=Twitter::Search.new, blog_search_client=GoogleBlog::Search)
      all.each do |search| 
        search.run_against_twitter(twitter_client) 
        search.run_against_blog_search(blog_search_client)
      end
    end
  end

  def run_against_twitter(twitter_client)
    twitter_results = fetch_twitter_search_results(twitter_client)
    twitter_results.each { |result| create_twitter_result(result) }
    save_latest_id(twitter_results)
  end

  def save_latest_id(results)
    return unless results.any?

    latest_id = results.sort_by(&:id).last.id
    update_attribute(:latest_id, latest_id)
  end

  def run_against_blog_search(blog_search_client=GoogleBlog::Search)
    blog_posts = blog_search_client.fetch(term)
    blog_posts.each do |bp|
      results.create(
        :created_at => bp.published_at,
        :body       => bp.content,
        :source     => "google",
        :url        => bp.url 
      )
    end 
  end

  private

  def fetch_twitter_search_results(twitter_client)
    twitter_client.
      containing(term).
      tap {|client| client.since_id(latest_id) if latest_id.present? }.
      language('en')
  end 

  def create_twitter_result(result)
    results.create(
      :created_at => result.created_at,
      :body       => result.text,
      :source     => "twitter",
      :url        => "http://twitter.com/#{result.from_user}/statuses/#{result.id}"
    )
  end
end
