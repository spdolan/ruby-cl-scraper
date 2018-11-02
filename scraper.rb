require 'httparty'
require 'nokogiri'
require 'byebug'

def scraper
	zip_code = 27701
	mile_radius = 5

	url = "https://raleigh.craigslist.org/search/apa?search_distance=#{mile_radius}&postal=#{zip_code}&availabilityMode=0&sale_date=all+dates"
	unparsed_site = HTTParty.get(url)
	parsed_site = Nokogiri::HTML(unparsed_site)
	available = Array.new

	listings = parsed_site.css("p.result-info")

	listings.each do |listing|
		house = {
			title: listing.css("a").text.strip.split("\n").first,
			price: listing.css("span.result-meta").css("span.result-price").text.strip.gsub("$", "").to_i,
			pics: listing.css("span.result-meta").css("span.result-tags").text.strip.split("\n").first.include?("pic"),
			url: listing.css('a')[0].attributes["href"].value
		}

		available << house
	end


	byebug
end

scraper