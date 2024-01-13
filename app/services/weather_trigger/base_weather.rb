# frozen_string_literal: true

class WeatherTrigger::BaseWeather
  def initialize
    raise 'Cannot instantiate WeatherTrigger::BaseWeather directly.' if instance_of?(WeatherTrigger::BaseWeather)
  end

  APIKEY = 'gDR29qzvlxyA5TOXebs2KffjIewsz2qd'
  LOCATION_KEY = '295609'
  URI_WEATHER = 'dataservice.accuweather.com'

  def self.create_forecasts(response, type = 'current')
    result = JSON.parse(response) if response
    result&.each do |weather|
      if weather.keys.include? 'Temperature'
        Forecast.create(temperature: weather['Temperature']['Metric']['Value'], type_weather: type,
                        epoch_time: Time.zone.at(weather['EpochTime']))
      end
    end
  end
end
