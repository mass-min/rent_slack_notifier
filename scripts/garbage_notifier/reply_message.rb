require 'bundler/setup'
Bundler.require
Dotenv.load '.env'
require_relative './create_message'

Slack.configure do |conf|
  conf.token = ENV['SLACK_API_TOKEN']
end

SLACK_USERNAME = 'rent-payment-bot'.freeze

client = Slack::RealTime::Client.new
client.on :hello do
  puts "Successfully connected, welcome '#{client.self.name}' to the '#{client.team.name}' team at https://#{client.team.domain}.slack.com."
end

client.on :message do |data|
  case data.text
  when "おじさん家賃支払い確認して" then
    client.message channel: data.channel, text: "<@#{data.user}>\n#{CreateMessage.run}"
  when /^おじさん家賃確認/ then
    client.message channel: data.channel, text: "<@#{data.user}>\n#{CreateMessage.run}"
  when /^bot/ then
    client.message channel: data.channel, text: "ごめんなさい <@#{data.user}>、よく分かりません"
  end
end

client.on :close do |_data|
  puts "Client is about to disconnect"
end

client.on :closed do |_data|
  puts "Client has disconnected successfully!"
end

client.start!
