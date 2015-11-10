# Encoding: utf-8

# B144 Scraper
# Example Usage:
#   ruby scraper.rb "סוכנויות_רכב" 10
#   ruby scraper.rb "צלמים_וסטודיו_לצילום/צילום_אירועים/" 5
# 
# 

if ARGV.empty?
  raise "Please send at least a segment term to scrape in hebrew. ie: 'סוכנויות_רכב'"
else
  segment_to_scrape = ARGV[0].strip
  number_of_pages = ARGV[1].nil? || ARGV.last.to_i <= 0 ? 1 : ARGV[1].to_i
end

require 'mechanize'
# Agent
puts "Initilizing scraper.."
agent = Mechanize.new

puts "connecting to B144 website.."
b144_current_page = agent.get("http://www.b144.co.il/#{segment_to_scrape}/")
puts "connected successfuly!"

companies_info = []

puts "\n\n You requested to scrape #{number_of_pages} pages. \n\n"


number_of_pages.times do |num_of_page|

  puts "Started scraping page #{num_of_page + 1}"
  # car companies more info links
  puts "scanning companies..."
  company_links1 = b144_current_page.search("a.rndtb_2 .rnd_float").map(&:parent)
  company_links2 = b144_current_page.search("a.rndtb2_2 .rnd_float").map(&:parent)
  company_links = (company_links1 + company_links2).flatten
  puts "#{company_links.size} were found \n\n"

  puts "Connecting to each company page and see if it has a website \n\n"
  #Temp Car companies info
  temp_companies_info = []
  company_links.each_with_index do |link, index|

    puts "\n\nGetting company page #{index + 1}..."
    company_page = agent.get(link.attributes["href"].value)
    puts "Connect to page #{index + 1}! \n\n"

    company_name = company_page.at(".dvm11").text
    company_website_link = company_page.at("[itemprop=url]")
    company_website_link_hidden = company_website_link.parent.attributes["style"].value.include? "display:none"
    if company_website_link_hidden
      puts "Adding company #{index + 1} (#{company_name}) because it doesn't have a website..."
      temp_companies_info.push({
        name: company_name,
        address: company_page.at("[text()*='כתובת:']").text.gsub("\n", "").gsub("\r", "").gsub("\t", ""),
        phone: company_page.at("[text()*='נייד:']").parent.text.gsub("נייד:", ""),
        url: company_page.uri.to_s
      })
    else
      puts "Skipping company #{index + 1} (#{company_name}) because it has a website..."
    end
  end

  puts "\n\n #{temp_companies_info.size} companies without a website were found on page #{num_of_page + 1}! :)"

  companies_info.push(temp_companies_info)

  if num_of_page < number_of_pages
    pagination = b144_current_page.at("#center_tdPagesNumTblFooter")
    current_page = pagination.at(".td_paging_on").text.to_i
    if current_page <= 2
      next_page_position = current_page
    else
      next_page_position = 3
    end
    puts "Possible next page -------> #{pagination.search(".td_plain")[next_page_position].text.to_i}"
    next_page_link = pagination.search(".td_plain")[next_page_position].at("a").attributes["href"].value
    b144_current_page = agent.get(next_page_link)
  end

end

companies_info = companies_info.flatten

puts "\n\n #{companies_info.size} companies without a website were found in total! :)"

companies_info.each do |company|
  puts "Name: #{company[:name]}, Phone: #{company[:phone]}, Address: #{company[:address]} \n"
end