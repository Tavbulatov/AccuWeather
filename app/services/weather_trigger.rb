class WeatherTrigger
  def self.call(type)
    case type
      when :current    then CurrentWeather.current
      when :historical then HistoricalWeather.hourly_historical
    end
  end
end
