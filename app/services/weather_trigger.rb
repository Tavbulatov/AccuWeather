class WeatherTrigger
  APIKEY = 'gDR29qzvlxyA5TOXebs2KffjIewsz2qd'.freeze
  LOCATION_KEY = '295609'.freeze
  URI_WEATHER = 'dataservice.accuweather.com'.freeze

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

  # Current Conditions
  def current_weather
    response = Net::HTTP.get("#{URI_WEATHER}", "/currentconditions/v1/#{LOCATION_KEY}?apikey=#{APIKEY}&language=ru")
    create_forecasts(response)
  end

  # Historical Current Conditions (past 24 hours)
  def hourly_historical_weather
    response = Net::HTTP.get("#{URI_WEATHER}",
                             "/currentconditions/v1/#{LOCATION_KEY}/historical/24?apikey=#{APIKEY}&language=ru")
    create_forecasts(response, :historical)
  end

  private
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
