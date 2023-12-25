every 1.minute do
  runner 'WeatherTrigger.call(:current)'
end

every 1.day, at: '4:30 am' do
  runner 'WeatherTrigger.call(:historical)'
end
