# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

<<~TEXT
  GET  |  /health(.json)                  |  v1  |  Health.
  GET  |  /weather/current(.json)         |  v1  |  Current temperature.
  GET  |  /weather/historical(.json)      |  v1  |  Temperature in the last 24 hours.
  GET  |  /weather/by_time(.json)         |  v1  |  By time.
  GET  |  /weather/historical/max(.json)  |  v1  |  Max temperature in the last 24 hours.
  GET  |  /weather/historical/min(.json)  |  v1  |  Min temperature in the last 24 hours.
  GET  |  /weather/historical/avg(.json)  |  v1  |  Average temperature in the last 24 hours
TEXT

module Weather
  class API < Grape::API
    version 'v1', using: :header, vendor: 'twitter'
    format :json

    rescue_from ActiveRecord::RecordNotFound do |_e|
      error!({ error: 'Not Found' }, 404)
    end

    desc 'Health.'
    get :health do
      status :ok
    end

    resources :weather do
      desc 'Current temperature.'
      get :current do
        Forecast.current
      end

      desc 'Hourly temperature for the last 24 hours'
      get :historical do
        Forecast.historical
      end

      desc 'By time.'
      params do
        requires :timestamp, type: Integer, desc: 'Timestamp.'
      end
      get 'by_time/:timestamp' do
        Forecast.by_time(params[:timestamp])['temperature']
      end

      resources :historical do
        desc 'Max temperature in the last 24 hours'
        get :max do
          Forecast.max_t
        end

        desc 'Min temperature in the last 24 hours'
        get :min do
          Forecast.min_t
        end

        desc 'Average temperature in the last 24 hours'
        get :avg do
          Forecast.avg
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
