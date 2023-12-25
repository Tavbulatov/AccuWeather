# frozen_string_literal: true

class Forecast < ApplicationRecord
  scope :sorted,     -> { order(created_at: :desc) }
  scope :day_ago,    -> { sorted.where('created_at > ?', 1.day.ago) }

  scope :current,    -> { sorted.where(type_weather: :current).first.temperature }
  scope :max_t,      -> { day_ago.maximum(:temperature) }
  scope :min_t,      -> { day_ago.minimum(:temperature) }
  scope :avg,        -> { day_ago.average(:temperature) }

  def self.historical
    day_ago.where(type_weather: :historical).select('temperature, epoch_time').limit(24).as_json(except: :id)
  end

  def self.by_time(epoch_time)
    time = Time.zone.at(epoch_time)
    current_time = Time.current

    raise ActiveRecord::RecordNotFound if time > current_time || time < current_time - 3.hours

    result = [where('epoch_time >= ?', time).first, where('epoch_time <= ?', time).first].compact
    forecast_after, forecast_before = result

    return result.first if result.length == 1

    (forecast_after.epoch_time - time).abs < (forecast_before.epoch_time - time).abs ? forecast_after : forecast_before
  end
end
