require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students = []
    index = Nokogiri::HTML(open(index_url))

    index.css("div.roster-cards-container").each { |card|
      card.css("div.student-card").each { |student|
        #binding.pry
        students << {
          :profile_url => student.css("a")[0].values.join(""),
          :name => student.css("h4")[0].text,
          :location => student.css("p")[0].text,
        }
      }
    }

    students

  end

  def self.scrape_profile_page(profile_url)
    profile = Nokogiri::HTML(open(profile_url))
    profile_hash = {}

    profile.css("div.social-icon-container").children.each { |child| # profile.css("div.social-icon-container").children[1].attribute("href").value
      child.each { |data|
        text = data[1]

        if text.include? "twitter"
          profile_hash[:twitter] = text
        elsif text.include? "github"
          profile_hash[:github] = text
        elsif text.include? "linkedin"
          profile_hash[:linkedin] = text
        else
          profile_hash[:blog] = text
        end
      }
    }

    if profile.css("div.profile-quote")
      profile_hash[:profile_quote] = profile.css("div.profile-quote").text
    end

    if profile.css("div.details-container p")
      profile_hash[:bio] = profile.css("div.details-container p").text
    end

    profile_hash
    

  end

end

