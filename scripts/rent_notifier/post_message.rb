require 'bundler/setup'
Bundler.require
Dotenv.load '.env'
require_relative '../slack_notifier'
require_relative './create_message'

class PostMessage
  # SLACK_CHANNEL = '#tokyo-house-keeping'.freeze
  SLACK_CHANNEL = '#slack-test'.freeze
  SLACK_ICON_EMOJI = ':money_mouth_face:'.freeze
  SLACK_USERNAME = '家賃回収おじさん'.freeze

  def self.run
    message = CreateMessage.run
    SlackNotifier.send_message(message, SLACK_CHANNEL, SLACK_ICON_EMOJI, SLACK_USERNAME)
  end
end

PostMessage.run