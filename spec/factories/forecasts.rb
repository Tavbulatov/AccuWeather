# frozen_string_literal: true

FactoryBot.define do
  sequence :temperature

  factory :forecast do
    epoch_time { Time.current }
    type_weather { 'current' }
    temperature
  end
end
