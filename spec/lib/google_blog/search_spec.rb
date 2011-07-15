require 'spec_helper'
require 'google_blog/search'

describe GoogleBlog::Search do

  subject { GoogleBlog::Search }

  let (:json_file_path) { File.read(File.join(File.dirname(__FILE__), "..", "..", "fixtures", "google_blog_search_results.json")) }
  let (:google_api_response) { JSON.parse(json_file_path) }

  let (:google_api_results) { google_api_response["responseData"]["results"] }

  before do
    subject.stubs(:get => google_api_response)
  end

  it "should fetch results from the Google API for each page" do
    number_of_page_results = google_api_response["responseData"]["cursor"]["pages"].size
    subject.fetch("BDD")

    number_of_page_results.times do |i|
      google_api_url = "http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=BDD&rsz=large&start=#{i * 8}"
      should have_received(:get).with(google_api_url)
    end
  end

  it "should return the number of blog posts contained in the response" do 
    blog_posts = subject.fetch("BDD")

    blog_posts.size.should == google_api_results.size * 8
  end

  # TODO: remove duplication
  it "should assign title from the reponse's 'titleNoFormatting' to the returned blog post" do
    blog_posts = subject.fetch("BDD")

    first_result = google_api_results.first
    blog_post = blog_posts.first
    blog_post.title.should == first_result["titleNoFormatting"]
  end

  it "should assign title from the reponse's 'content' to the returned blog post" do
    blog_posts = subject.fetch("BDD")

    first_result = google_api_results.first
    blog_post = blog_posts.first
    blog_post.content.should == first_result["content"]
  end

  it "should assign url from the reponse's 'postURL' to the returned blog posts" do
    blog_posts = subject.fetch("BDD")

    first_result = google_api_results.first
    blog_post = blog_posts.first
    blog_post.url.should == first_result["postUrl"]
  end

  it "should assign url from the reponse's 'postURL' to the returned blog posts" do
    blog_posts = subject.fetch("BDD")

    first_result = google_api_results.first
    blog_post = blog_posts.first
    blog_post.published_at.should == first_result["publishedDate"]
  end
end
