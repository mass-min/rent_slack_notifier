require 'bundler/setup'
Bundler.require
Dotenv.load '.env'
require_relative '../slack_notifier'
require_relative './create_message'

module GarbageNotifier
  class PostMessage
    # SLACK_CHANNEL = '#tokyo-house-keeping'.freeze
    SLACK_CHANNEL = '#slack-test'.freeze
    SLACK_ICON_EMOJI = ':face_vomiting:'.freeze
    SLACK_USERNAME = 'ゴミ出しおじさん'.freeze

    def self.run
      message = GarbageNotifier::CreateMessage.run
      SlackNotifier.send_message(message, SLACK_CHANNEL, SLACK_ICON_EMOJI, SLACK_USERNAME)
    end
  end
end

GarbageNotifier::PostMessage.run