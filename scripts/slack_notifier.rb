require 'bundler/setup'
Bundler.require
Dotenv.load '.env'

module SlackNotifier
  SLACK_CHANNEL = '#slack-test'.freeze
  SLACK_ICON_EMOJI = ':money_mouth_face:'.freeze
  SLACK_USERNAME = '家賃回収おじさん'.freeze

  def self.send_message(text = 'test',
          channel = SlackNotifier::SLACK_CHANNEL,
          icon_emoji = SlackNotifier::SLACK_ICON_EMOJI,
          username = SlackNotifier::SLACK_USERNAME)

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