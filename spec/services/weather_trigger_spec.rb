require 'rails_helper'

RSpec.describe WeatherTrigger, type: :service do
  describe '.call' do
    context 'when type is :current' do
      let(:current_weather) { WeatherTrigger::CurrentWeather }

      it 'calls the current_weather method of CurrentWeather' do
        allow(current_weather).to receive(:current)
        described_class.call(:current)
        expect(current_weather).to have_received(:current)
      end

      it 'creates a Forecast model of type :current' do
        expect { described_class.call(:current) }.to change { Forecast.where(type_weather: :current).count }.by(1)
      end
    end

    context 'when type is :historical' do
      let(:historical_weather) { WeatherTrigger::HistoricalWeather }

      it 'calls the hourly_historical_weather method of HistoricalWeather' do
        allow(historical_weather).to receive(:hourly_historical)
        described_class.call(:historical)
        expect(historical_weather).to have_received(:hourly_historical)
      end

      it 'creates a Forecast model of type :historical' do
          expect { described_class.call(:historical) }.to change(Forecast, :count).by(24)
      end
    end
  end
end
