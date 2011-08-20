module GoogleBlog
  class BlogPost
    attr_reader :title, :url, :published_at, :content

    def initialize(attributes)
      @title        = attributes[:title]
      @content      = attributes[:content]
      @url          = attributes[:url]
      @published_at = attributes[:published_at]
    end
  end

  class Search
    include HTTParty
    format :json

    PER_PAGE = 8
    URL = "http://ajax.googleapis.com/ajax/services/search/blogs?v=1.0&q=%s&rsz=large&start=%s"

    class << self
      def fetch(search_term)
        start = 0
        response = get(URL % [URI.escape(search_term), start])
        number_of_pages = response["responseData"]["cursor"]["pages"].size
        results = create_results(response)
        first_page_offset = 1

        first_page_offset.upto(number_of_pages - first_page_offset) do |i|
          start = i * PER_PAGE
          response = get(URL % [search_term, start])
          results = results + create_results(response)
        end

        return results
      end

      private

      def create_results(response)
        blog_posts = []

        results = response["responseData"]["results"]
        results.each do |result|
          blog_posts << BlogPost.new(
                         :title        => result['titleNoFormatting'],
                         :content      => result['content'],
                         :url          => result['postUrl'],
                         :published_at => result['publishedDate']
          )
        end if results.present?

        return blog_posts
      end
    end
  end
end
