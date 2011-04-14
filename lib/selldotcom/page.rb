module SellDotCom
  class Page
     attr_accessor :page

     def initialize(result)
       @page           ||= {}
       @page[:title]     = result[:title]
       @page[:url]       = result[:url]
       @page[:posted_on] = Time.parse(result[:posted_on])
       @page[:item_id]   = result[:item_id]
       parse      
     end

     def parse
       response  = Typhoeus::Request.get(@page[:url])      
       doc       = Nokogiri::HTML(response.body)
       @page[:seller_name] = doc.xpath("//a[@class='member']/u").text
       @page[:price]       = parse_price(doc.xpath("//div[@id='action']//td/div[@style='text-align:center;font-family:verdana,arial,sans-serif;font-size:large;font-weight:bold;color:green;']").text)
       @page[:description] = doc.xpath("//font[@face='Verdana,Geneva,Arial']/comment()[.=' google_ad_section_start '][1]/../..").text
       @page
     end
     
################################################################################     
     private
     
     def parse_price(text)
       text.gsub(/([\$])/, "").to_f
     end
     
   end
end