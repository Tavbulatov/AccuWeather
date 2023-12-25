# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'WeatherAPI', type: :request do
  describe Weather::API do
    let!(:forecasts) { create_list(:forecast, 10, type_weather: 'historical') }
    let!(:forecast) { create(:forecast, epoch_time: Time.current) }

    context 'GET /health' do
      it 'returns status 200' do
        get '/health'
        expect(response.status).to eq(200)
      end
    end

    context 'GET /weather/current' do
      it 'returns the current temperature' do
        get '/weather/current'
        expect(json).to eq forecast.temperature
      end
    end

    context 'GET /weather/historical' do
      it 'returns hourly temperature for the last 24 hours' do
        get '/weather/historical'
        expect(json).to eq Forecast.historical
      end
    end

    context 'GET /weather/by_time' do
      it 'return temperature by time.' do
        get "/weather/by_time/#{Time.current.to_i}"
        expect(json).to eq Forecast.by_time(Time.current.to_i).temperature
      end

      it 'epoch time exceeds current time' do
        get "/weather/by_time/#{Time.current.to_i + 1.minute.to_i}"
        expect(json).to eq({ 'error' => 'Not Found' })
      end

      it 'epoch time is less than current time by more than 3 hours' do
        get "/weather/by_time/#{Time.current.to_i - 4.hours.to_i}"
        expect(json).to eq({ 'error' => 'Not Found' })
      end

      it 'return timestamp is invalid.' do
        get '/weather/by_time/:timestamp'
        expect(json).to eq({ 'error' => 'timestamp is invalid' })
      end
    end

    context 'GET /weather/historical/max' do
      it 'max temperature in the last 24 hours' do
        get '/weather/historical/max'
        expect(json).to eq Forecast.max_t
      end
    end

    context 'GET /weather/historical/min' do
      it 'min temperature in the last 24 hours' do
        get '/weather/historical/min'
        expect(json).to eq Forecast.min_t
      end
    end

    context 'GET /weather/historical/avg' do
      it 'average temperature in the last 24 hours' do
        get '/weather/historical/avg'
        expect(json.to_f).to eq Forecast.avg.to_f
      end
    end
  end
end
