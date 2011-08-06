require 'spec_helper'

describe Search do

  it { should validate_presence_of :term }
  it { should have_and_belong_to_many :brands }
  it { should have_many :results }

  describe ".run" do

    subject { Search }

    let (:searches) do 
      3.times.collect {|x| stub("search-#{x}", :run_against_twitter => nil, :run_against_blog_search => nil) }
    end
    let (:twitter_client) { stub() } 
    let (:blog_search_client) { stub() } 

    before do 
      Search.stubs(:all).returns(searches)
      Search.run(twitter_client, blog_search_client)
    end 

    it { should have_received(:all) }

    it "runs a twitter search for each search term" do
      searches.each do |search|
        search.should have_received(:run_against_twitter).with(twitter_client)
      end
    end

    it "runs a google blog search for each search term" do
      searches.each do |search|
        search.should have_received(:run_against_blog_search).with(blog_search_client)
      end
    end
  end

  describe "#run_against_twitter" do

    let (:search_term) { "test search term" }
    let (:twitter_client) { stub() } 
    let (:twitter_searches) { [] }

    before do
      subject.stubs(:term => search_term, :save_latest_id => nil, :results => stub(:create => nil), :update_attributes => nil)
      twitter_client.stubs(:containing => twitter_client, :since_id => twitter_client, :language => twitter_searches)
      3.times do |i|
        twitter_searches << stub("twitter search for #{subject.term} #{i}", twitter_search_result([subject.term, i].join(" "))) 
      end
    end

    it "updates the message id of the latest search" do
      subject.run_against_twitter(twitter_client)

      should have_received(:save_latest_id).with(twitter_searches)
    end

    it "creates a new search result for each twitter result" do
      subject.run_against_twitter(twitter_client)

      twitter_searches.each do |result|
        expected_create_params = {
          created_at: result.created_at,
          body: result.text,
          source: "twitter",
          url: "http://twitter.com/#{result.from_user}/statuses/#{result.id}" 
        }
        subject.results.should have_received(:create).with(has_entries(expected_create_params))
      end
    end

    context "when first executed" do

      it "runs a twitter search without specifying latest_id" do
        subject.run_against_twitter(twitter_client)

        twitter_client.should have_received(:language).with('en')
        twitter_client.should have_received(:containing).with(search_term)
      end
    end

    context "when executed again" do

      it "runs a twitter search specifying latest_id" do
        subject.stubs(:latest_id => '999')

        subject.run_against_twitter(twitter_client)

        twitter_client.should have_received(:language).with('en')
        twitter_client.should have_received(:since_id).with('999')
        twitter_client.should have_received(:containing).with(search_term)
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

  describe "#save_latest_id" do
    
    context "with results" do 

      let(:results) do 
        [ Hashie::Mash.new({:id => 3}), 
          Hashie::Mash.new({:id => 6}), 
          Hashie::Mash.new({:id => 2}) ]
      end 

      before do
        subject.stubs(:update_attribute => nil)
        subject.save_latest_id(results)
      end

      it { should have_received(:update_attribute).with(:latest_id, 6) }
    end

    context "without results" do 

      before do
        subject.stubs(:update_attribute => nil)
        subject.save_latest_id([])
      end

      it { should_not have_received(:update_attribute) }
    end
  end

  describe "#run_against_blog_search" do

    let (:search_term) { "bdd casts" }

    let (:search_results) do
      3.times.collect do |i| 
        stub("search result #{i}", 
          :content      => "content #{i}",
          :url          => "http://example#{i}.com",
          :published_at => i.hours.ago
        )
      end
    end

    let (:blog_client) { stub("blog client", :fetch => search_results) }

    before do
      subject.stubs(:term => search_term, :results => stub(:create => nil))
    end

    it 'fetches results' do
      subject.run_against_blog_search(blog_client)

      blog_client.should have_received(:fetch).with(search_term)
    end

    it 'creates a new search result for each result' do
      subject.run_against_blog_search(blog_client)

      search_results.each do |sr|
        expected_create_params = {
          :body       => sr.content,
          :url        => sr.url,
          :source     => 'google',
          :created_at => sr.published_at
        }
        subject.results.should have_received(:create).with(has_entries(expected_create_params))
      end
    end
  end
end
