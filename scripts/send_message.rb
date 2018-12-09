require "bundler/setup"
require 'slack-ruby-client'

TOKEN = 'xoxb-290786944402-498170702880-IkHBbrHCoV3i1YmpFHa02AO0'

Slack.configure do |conf|
  conf.token = TOKEN
end

client = Slack::RealTime::Client.new
# client = Slack::Web::Client.new

# client.chat_postMessage(channel: '#tokyo-house-keeping', text: 'Test post'

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
