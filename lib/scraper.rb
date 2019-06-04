require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    html = open(index_url)
    doc = Nokogiri::HTML(html)
    students = doc.css(".roster-cards-container .student-card")
    
    array = students.collect do |student|
      students_hash = {}
      students_hash[:name] = student.css(".student-name").text
      students_hash[:location] = student.css(".student-location").text
      students_hash[:profile_url] = student.css("a").attribute("href").value
      students_hash
    end

  end

  def self.scrape_profile_page(profile_url)
    html = open(profile_url)
    doc = Nokogiri::HTML(html)
    links = doc.css(".social-icon-container a").map {|link| link['href']}
    profile_quote = doc.css(".profile-quote").text.chomp
    bio = doc.css(".bio-content .description-holder").text.strip
    twitter = nil
    linkedin = nil
    github = nil
    blog = nil
    student_profile_hash = {}

    links.each do |link|
      if link.include?("twitter")
        twitter = link
      elsif link.include?("linkedin")
        linkedin = link
      elsif link.include?("github")
        github = link
      else
          blog = link
      end
    end


    student_profile_hash[:twitter] = twitter unless !twitter
    student_profile_hash[:linkedin] = linkedin unless !linkedin
    student_profile_hash[:github] = github unless !github
    student_profile_hash[:blog] = blog unless !blog
    student_profile_hash[:profile_quote] = profile_quote
    student_profile_hash[:bio] = bio 
    student_profile_hash
end

end

