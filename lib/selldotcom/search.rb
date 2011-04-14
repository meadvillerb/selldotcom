module SellDotCom
  class Search

    attr_accessor :search_phrase
    attr_reader   :search_uri, :results

    def initialize(search_phrase)
      @search_phrase  ||= search_phrase
      @search_uri     ||= search_uri
    end

    def search
      response = Typhoeus::Request.get(@search_uri)
      @results = parse(response.body)
    end
  
################################################################################
    private
  
    def parse(html)
      doc = Nokogiri::XML(html)
      results = []
      doc.xpath("//item").each do |item|
        title     = item.xpath("title").text
        url       = item.xpath("link").text
        posted_on = item.xpath("pubDate").text
        item_id   = parse_item_id(url)
        results << { :title => title, :url => url, :item_id => item_id, :posted_on => posted_on }
      end
      results
    end
  
    def parse_item_id(url)
      /sell.com\/([\S]+)\z/.match(url)[1]
    end
  
    def search_uri
      "http://www.sell.com/search/index.x?search=#{URI.encode(@search_phrase)}+per_page%3A500+category%3A759&format=rss"
    end

  end
end