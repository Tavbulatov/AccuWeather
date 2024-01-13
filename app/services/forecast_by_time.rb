# frozen_string_literal: true

class ForecastByTime
  def self.closest_to_given_time(epoch_time)
    time = Time.zone.at(epoch_time)
    current_time = Time.current

    raise ActiveRecord::RecordNotFound if time > current_time || time < current_time - 3.hours

    forecast_after, forecast_before = [
      Forecast.where('epoch_time >= ?', time).first,
      Forecast.where('epoch_time <= ?', time).first
    ].compact

    return forecast_after if forecast_before.nil?

    (forecast_after.epoch_time - time).abs < (forecast_before.epoch_time - time).abs ? forecast_after : forecast_before
  end
end
