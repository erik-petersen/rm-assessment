# who = 'World'
# i = 0
#
# while (i < 10)
#   if (i % 2 == 0)
#  	puts i
#   end # end if statement
#   i += 1;
# end # end while loop
#
# puts ''
#
# puts 'Hello, World'
# print 'What is your name? '
# name = gets
# puts "Hello, #{name}"
#
# new_name = 'Bob'
# name_answer = "y"
# print "Hello, #{new_name}! It is #{new_name}, isn't it? "
# name_answer = gets.chomp
# if (name_answer == 'y')
#   print "That's what I thought! Nice to meet you, #{new_name}!"
# else
#   print "I'm terribly sorry! What is is your name? "
#   new_name = gets
#   print "Nice to meet you, #{new_name}! "
# end

# require 'socket'
# ip = Socket::getaddrinfo(Socket.gethostname,"echo")
# puts ip
#
# ips = Socket.ip_address_list
# puts ips

# bar = geo_json.keys
# puts bar

# RoleModel Software Assessment by Erik Petersen
# Create a Ruby program that:
# Leverages a few APIs
# Looks up location of executing machine (leverage IP Address/Geocoding)
# Gets the 7 day weather forecast for that location
# Prints out the high and low temps for each day
# Bonus: graph the values with a bar chart

require 'net/http'
require 'net/https'
require 'uri'
require 'json'

# assign variables
geo_data = []
weather_data = Hash.new # thank you, https://ruby-doc.org/core-2.4.1/Hash.html
weather_forecast = Hash.new
puts ""

# fetch geolocation data
# thank you, https://ipgeolocation.io/documentation/ip-geolocation-api.html & https://curlconverter.com/ruby/
uri_geo = URI('https://api.ipgeolocation.io/ipgeo')
params = {
  :apiKey => '577762717cb24b2393104d4a96011353'
} # end geolocation params
uri_geo.query = URI.encode_www_form(params)
geo_response = Net::HTTP.get_response(uri_geo)
geo_json = JSON.parse(geo_response.body)
geo_ip = geo_json["ip"]
geo_lat = geo_json["latitude"]
geo_long = geo_json["longitude"]
geo_time_zone = geo_json['time_zone']

# fetch 7 day weather forecast data
# thank you, https://www.weatherapi.com/api-explorer.aspx#forecast
uri_weather = URI('http://api.weatherapi.com/v1/forecast.json?')
params = {
  :key => '73678c6da33b4adca1e173402232102',
  :q => geo_ip,
  :days => '7',
  :aqi => 'yes',
  :alerts => 'no'
} # end weather params
uri_weather.query = URI.encode_www_form(params)
weather_response = Net::HTTP.get_response(uri_weather)
weather_json = JSON.parse(weather_response.body)

# grab location data
weather_json['location'].each { |moniker, worth|
  weather_data[moniker] = worth
} # end weather_json.each

# display location data
puts "#{weather_data['name']}, #{weather_data['region']}"
puts "#{weather_data['localtime'][0,10]}"
puts "#{weather_data['localtime'][11,5]}", "\n\n"

# display current weather
puts "Your Current Weather"
puts "Temperature: #{weather_json['current']['temp_f']} F"
puts "High: #{weather_json['forecast']['forecastday'][0]['day']['maxtemp_f']} F / Low: #{weather_json['forecast']['forecastday'][0]['day']['mintemp_f']} F"
puts "Condition: #{weather_json['current']['condition']['text']}"
puts "Windspeed: #{weather_json['current']['wind_mph']} mph"
puts "Humidity: #{weather_json['current']['humidity']}%"
puts "Feels Like: #{weather_json['current']['feelslike_f']} F"
puts "Visibility: #{weather_json['current']['vis_miles']} miles"
puts "UV Index: #{weather_json['current']['uv']}"

puts  "\n\n", "Your 7 Day Forecast"

# display 7 day forecast data
weather_json['forecast']['forecastday'].each { |moniker, worth|

  # if the date is today's date, put "Today", otherwise put the date
  if moniker['date'] == Time.now.to_s[0,10]
    puts "Today:"
  else
    puts "Date: #{moniker['date']}"
  end # Today vs Date

  puts "High: #{moniker['day']['maxtemp_f']} F / Low: #{moniker['day']['mintemp_f']} F"
  puts "Condition: #{moniker['day']['condition']['text']}"
  puts "This Is Your Condition Icon For The Day: #{moniker['day']['condition']['icon']} We'll Give You Another One Tomorrow"
  puts "Chance of Rain: #{moniker['day']['daily_chance_of_rain']}%"
  puts "Sunrise: #{moniker['astro']['sunrise']}"
  puts "Sunset: #{moniker['astro']['sunset']}"
  puts "Moonrise: #{moniker['astro']['moonrise']}"
  puts "Moonset: #{moniker['astro']['moonset']} \n\n"

  puts "Hourly:"
  # display hourly data for the day with nested loop
  i = 0
  while i < 24
    puts moniker['hour'][i]['time'][11,5]
    puts "Condition: #{moniker['hour'][i]['condition']['text']}"
    puts "Condition Icon: #{moniker['hour'][i]['condition']['icon']}"
    puts "Temperature: #{moniker['hour'][i]['temp_f']} F"
    puts "Feels Like: #{moniker['hour'][i]['feelslike_f']} F"
    puts "Heat Index: #{moniker['hour'][i]['heatindex_f']} F"
    puts "Wind Chill: #{moniker['hour'][i]['windchill_f']} F"
    puts "Wind Direction: #{moniker['hour'][i]['wind_dir']}"
    puts "Windspeed: #{moniker['hour'][i]['wind_mph']} mph"
    puts "Chance of Rain: #{moniker['hour'][i]['chance_of_rain']} %"
    puts "Precipitation: #{moniker['hour'][i]['precip_in']} in "
    puts "Dewpoint: #{moniker['hour'][i]['dewpoint_f']} F"
    puts "Visibility: #{moniker['hour'][i]['vis_miles']} miles"
    puts "Barometric Pressure: #{moniker['hour'][i]['pressure_in']} in"
    puts "\n"
    i += 1
  end # end display hourly data loop

} # end display 7 day forecast
