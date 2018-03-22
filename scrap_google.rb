require 'mechanize'
require 'open-uri'
require 'nokogiri'
require 'uri'
require 'fileutils'

agent = Mechanize.new {|agent|
	agent.user_agent_alias = "Linux Firefox"
}   


agent.pluggable_parser.default = Mechanize::Download
agent.set_proxy '172.16.2.30', 8080

page = agent.get('https://images.google.com/')  

google_form = page.form('f')

puts "Enter the keyword\n"

keyword = gets.chomp

FileUtils.mkdir_p keyword

Dir.chdir keyword

google_form.q = keyword

page1 = agent.submit(google_form)

url = page1.uri

doc = Nokogiri::HTML(open(url, :proxy => 'http://172.16.2.30:8080'))

img = doc.at_css('#ires')

nodeset = img.css('img')


brk = 0
for x in nodeset do
	brk = brk + 1
	if brk == 11
		break
	end	
	str = x.to_s()
			
	count = 0
	char = 0
	start = 0
	en = 0

	str.each_char do |i|
		char = char + 1
		if i == '"'
			count = count + 1
		end	

		if count == 2
			start = char
		end
		
		if count == 3
			en = char
		end

	end	

	img_url = str[(start)..(en)]	
	empty = str[(start)..(en)].gsub('"','')

	agent.get(empty).save keyword
end	
  