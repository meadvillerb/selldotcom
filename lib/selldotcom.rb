require 'typhoeus'
require 'nokogiri'
require 'time'

require_relative 'selldotcom/version'
require_relative 'selldotcom/search'
require_relative 'selldotcom/page'

module SellDotCom
  def self.is_active?(url)
    suspended_image_xpath = "//img[@src='http://i.sell.com/i/i_suspend.gif']"
    response = Typhoeus::Request.get(url)
    doc = Nokogiri::HTML(response.body)
    doc.xpath(suspended_image_xpath).count < 1 ? true : false
  end
end