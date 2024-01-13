# frozen_string_literal: true

class Forecast < ApplicationRecord
  scope :sorted,     -> { order(created_at: :desc) }
  scope :day_ago,    -> { sorted.where('created_at > ?', 1.day.ago) }

  def self.historical
    day_ago.where(type_weather: :historical).select('temperature, epoch_time').limit(24).as_json(except: :id)
  end

  def self.current
    sorted.where(type_weather: :current).first.temperature
  end

  def self.max_t
    day_ago.maximum(:temperature)
  end

  def self.min_t
    day_ago.minimum(:temperature)
  end

  def self.avg
    day_ago.average(:temperature)
  end

  def self.by_time(epoch_time)
    ForecastByTime.call(epoch_time)
  end
end
