# frozen_string_literal: true
class WeatherTrigger::HistoricalWeather < WeatherTrigger::BaseWeather
  # Historical Current Conditions (past 24 hours)
  def self.hourly_historical
    response = Net::HTTP.get(URI_WEATHER,
                            "/currentconditions/v1/#{LOCATION_KEY}/historical/24?apikey=#{APIKEY}&language=ru")
    create_forecasts(response, :historical)
  end
end
