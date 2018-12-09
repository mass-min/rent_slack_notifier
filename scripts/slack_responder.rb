require 'bundler/setup'
require 'slack-ruby-client'

TOKEN = ENV['SLACK_API_TOKEN']

Slack.configure do |conf|
  conf.token = TOKEN
end

client = Slack::RealTime::Client.new
client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  case data.text
  when 'bot hi' then
    client.message channel: data.channel, text: "Hi <@#{data.user}>!"
  when 'こんにちは' then
    client.message channel: data.channel, text: "こんにちは、<@#{data.user}>!"
  when /^bot/ then
    client.message channel: data.channel, text: "Sorry <@#{data.user}>, what?"
  end
end

client.on :close do |_data|
  puts "Client is about to disconnect"
end

client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end

client.start!
