# frozen_string_literal: true

class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.datetime :epoch_time
      t.string :type_weather, default: 'current', index: true
      t.integer :temperature, null: false
      t.timestamps
    end
  end
end
