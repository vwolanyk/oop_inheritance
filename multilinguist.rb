require 'httparty'
require 'json'


# This class represents a world traveller who knows what languages are spoken in each country
# around the world and can cobble together a sentence in most of them (but not very well)
class Multilinguist

  TRANSLTR_BASE_URL = "http://www.transltr.org/api/translate"
  COUNTRIES_BASE_URL = "https://restcountries.eu/rest/v2/name"
  #{name}?fullText=true
  #?text=The%20total%20is%2020485&to=ja&from=en


  # Initializes the multilinguist's @current_lang to 'en'
  #
  # @return [Multilinguist] A new instance of Multilinguist
  def initialize
    @current_lang = 'en'
  end

  # Uses the RestCountries API to look up one of the languages
  # spoken in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] A 2 letter iso639_1 language code
  def language_in(country_name)
    params = {query: {fullText: 'true'}}
    response = HTTParty.get("#{COUNTRIES_BASE_URL}/#{country_name}", params)
    json_response = JSON.parse(response.body)
    json_response.first['languages'].first['iso639_1']
  end

  # Sets @current_lang to one of the languages spoken
  # in a given country
  #
  # @param country_name [String] The full name of a country
  # @return [String] The new value of @current_lang as a 2 letter iso639_1 code
  def travel_to(country_name)
    local_lang = language_in(country_name)
    @current_lang = local_lang
  end

  # (Roughly) translates msg into @current_lang using the Transltr API
  #
  # @param msg [String] A message to be translated
  # @return [String] A rough translation of msg
  def say_in_local_language(msg)
    params = {query: {text: msg, to: @current_lang, from: 'en'}}
    response = HTTParty.get(TRANSLTR_BASE_URL, params)
    json_response = JSON.parse(response.body)
    json_response['translationText']
  end
end

#   **** MATH GENIUS CLASS

class MathGenius < Multilinguist

# report_method
# Takes infinite arguments for numbers returns sum

  def report_total(*numbers)
    numbers.sum
  end

end


#   **** QUOTE COLLECTOR CLASS

class Quoter < Multilinguist

  attr_reader :quotes

  def initialize
    @quotes = {}
  end


  def new_quote(topic, quote)


    @quotes[topic.to_sym] = quote

  end

  def share_random_quote

    say_in_local_language(@quotes.values[rand(@quotes.length)])
  end

  def quote_by_topic(topic)
    @quotes.each do |k,v|
      if k == topic.to_sym
        puts v
        return v
      end
      end

  end
end

# TEST CASES FOR Quoter
me = Quoter.new

me.new_quote("freak", "What The Freak")
me.new_quote("world","Freak The World")
me.new_quote("gambling", "Lucky Old Ludite!")

p me.quotes

puts me.share_random_quote

me.quote_by_topic("freak")
