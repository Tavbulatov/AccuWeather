# frozen_string_literal: true

class WeatherTrigger
  APIKEY = 'gDR29qzvlxyA5TOXebs2KffjIewsz2qd'
  LOCATION_KEY = '295609'
  URI_WEATHER = 'dataservice.accuweather.com'

  def self.call(type)
    new.run(type)
  end

  def run(type)
    if type == :current
      current_weather
    else
      hourly_historical_weather
    end
  end

  private
  # Current Conditions
  def current_weather
    response = Net::HTTP.get(URI_WEATHER.to_s, "/currentconditions/v1/#{LOCATION_KEY}?apikey=#{APIKEY}&language=ru")
    create_forecasts(response)
  end

  # Historical Current Conditions (past 24 hours)
  def hourly_historical_weather
    response = Net::HTTP.get(URI_WEATHER.to_s,
                             "/currentconditions/v1/#{LOCATION_KEY}/historical/24?apikey=#{APIKEY}&language=ru")
    create_forecasts(response, :historical)
  end

  def create_forecasts(response, type = 'current')
    result = JSON.parse(response) if response
    result&.each do |weather|
      if weather.keys.include? 'Temperature'
        Forecast.create(temperature: weather['Temperature']['Metric']['Value'], type_weather: type,
                        epoch_time: Time.zone.at(weather['EpochTime']))
      end
    end
  end
end
