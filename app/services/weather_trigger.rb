# frozen_string_literal: true

class WeatherTrigger
  def self.call(type)
    case type
    when :current    then CurrentWeather.fetch_current
    when :historical then HistoricalWeather.fetch_hourly_historical
    end
  end
end
