class ForecastByTime
  def self.call(epoch_time)
    time = Time.zone.at(epoch_time)
    current_time = Time.current

    raise ActiveRecord::RecordNotFound if time > current_time || time < current_time - 3.hours

    result = [Forecast.where('epoch_time >= ?', time).first, Forecast.where('epoch_time <= ?', time).first].compact
    forecast_after, forecast_before = result

    return result.first if result.length == 1

    (forecast_after.epoch_time - time).abs < (forecast_before.epoch_time - time).abs ? forecast_after : forecast_before
  end
end
