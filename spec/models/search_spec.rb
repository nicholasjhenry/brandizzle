require 'spec_helper'

describe Search do
  it { should validate_presence_of :term }
  it { should belong_to :brand }
  it { should have_many :results }

  describe "#run_against_twitter" do
    let (:searches) do 
      3.times.collect {|x| stub("search-#{x}", :term => "search-#{x}", :results => stub(:create => nil)) }
    end

    let (:twitter_search_client) { stub() } 
    let (:twitter_searches) { [] }

    before do 
      searches.each do |search |
        twitter_searches << stub("twitter search for #{search.term}", twitter_search_result(search.term)) 
      end

      twitter_search_client.stubs(:containing => twitter_search_client, :language => twitter_searches)
      Search.stubs(:all).returns(searches)
      Search.run_against_twitter(twitter_search_client)
    end 

    it "should find all the searches" do
      Search.should have_received(:all)
    end

    it "runs a twitter search for each search term" do
      twitter_search_client.should have_received(:language).with('en').times(3)
      searches.each_with_index do |search, idx|
        twitter_search_client.should have_received(:containing).with(search.term)
      end
    end

    it "creates a new search result for each twitter result" do
      searches.each_with_index do |search, idx|
        result = twitter_searches[idx]
        search.results.should have_received(:create).with(has_entries({
          created_at: result.created_at,
          body: result.text,
          source: "twitter",
          url: "http://twitter.com/#{result.from_user}/statuses/#{result.id}" 
        }))
      end
    end

    def twitter_search_result(search_term)
      Hashie::Mash.new({
        created_at: "Sat, 11 Jun 2011 12:16:13 +0000", 
        from_user: "source", 
        from_user_id: 1234567, 
        from_user_id_str: "1234567",
        geo: nil,  
        id: 79522319185346561,
        id_str: "79522319185346561", 
        iso_language_code: "en", 
        metadata: Hashie::Mash.new({result_type: "recent"}), 
        profile_image_url: "http://a1.twimg.com/profile_images/1234567/profile.jpg", 
        source: "&lt;a href=&quot;http://www.tweetdeck.com&quot; rel=&quot;nofollow&quot;&gt;TweetDeck&lt;/a&gt;", 
        text: "this is a tweet for #{search_term}", 
        to_user_id: nil, 
        to_user_id_str: nil
      })
    end
  end
end
