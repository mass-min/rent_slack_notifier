require 'bundler/setup'
Bundler.require
Dotenv.load '.env'

module SlackNotifier
  DEFAULT_SLACK_CHANNEL = '#slack-test'.freeze
  DEFAULT_SLACK_ICON_EMOJI = ':star-struck:'.freeze
  DEFAULT_SLACK_USERNAME = 'テストおじさん'.freeze

  def self.send_message(text = 'test',
      channel = SlackNotifier::DEFAULT_SLACK_CHANNEL,
      icon_emoji = SlackNotifier::DEFAULT_SLACK_ICON_EMOJI,
      username = SlackNotifier::DEFAULT_SLACK_USERNAME)

    Slack.configure do |conf|
      conf.token = ENV['SLACK_API_TOKEN']
    end

    client = Slack::Web::Client.new
    client.chat_postMessage(
      channel: channel,
      text: text,
      icon_emoji: icon_emoji,
      username: username
    )
  end
end