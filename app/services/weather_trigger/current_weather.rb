# frozen_string_literal: true

class WeatherTrigger::CurrentWeather < WeatherTrigger::BaseWeather
  # Current Conditions
  def self.fetch_current
    response = Net::HTTP.get(URI_WEATHER, "/currentconditions/v1/#{LOCATION_KEY}?apikey=#{APIKEY}&language=ru")
    create_forecasts(response)
  end
end
