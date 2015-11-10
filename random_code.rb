require 'mechanize'
agent = Mechanize.new
page_test = agent.get("http://www.b144.co.il/%D7%A1%D7%95%D7%9B%D7%A0%D7%95%D7%99%D7%95%D7%AA_%D7%A8%D7%9B%D7%91/")
car_companies = page_test.search(".rnd_r_c")
car_company_links = page_test.search("a.rndtb_2")
car_info_links = []
links = page_test.search("a.rndtb_2")
links.size
info_links = []
links.each_with_index do |link, index|
info_links.push(link) if index.odd?
end
info_links.size
info_links.first
first_link = _
first_link.attributes
first_link.attributes["href"]
first_link.attributes["href"]["value"]
first_link.attributes["href"].value
first_link.click
Mechanize::Page::Link.new(first_link, agent, page_test)
clickable_first_link = Mechanize::Page::Link.new(first_link, agent, page_test)
clickable_first_link.click
member_page = _
memeber_page.links.s
member_page.links.size
member_page.link_with(text: "אתר")
member_page.at("[itemprop=url]")
member_page.link_with(itemprop: "url")
member_page.link_with(attribute: "itemprop")
member_page.at("[itemprop=url]")
member_page.at(".yankel")
member_page.title
member_page.at(".dvm11").text
member_page.at("[itemprop=url]")
member_page.at("[itemprop=url]").parent
member_page.at("[itemprop=url]").parent.visible?
member_page.at("[itemprop=url]").parent.css
member_page.at("[itemprop=url]").parent.attributes
member_page.at("[itemprop=url]").parent.attributes["style"]
member_page.at("[itemprop=url]").parent.attributes["style"].value
member_page.at("[itemprop=url]").parent.attributes["style"].value.include? "display:none"

