require 'bundler/setup'
Bundler.require
Dotenv.load '.env'
require_relative '../slack_notifier'
include SlackNotifier

class PostMessage
  class << self
    def run
      message = self.create_message
      SlackNotifier.send_message(message)
    end

    def create_message
      # Google Spread Sheetに接続
      session = GoogleDrive::Session.from_config('config.json')
      worksheet = session.spreadsheet_by_key(ENV['GOOGLE_DRIVE_SPREADSHEET_KEY']).worksheets[0]

      total_member_count = 9
      column_member_name = 4
      column_beginning_month = 6 # 居住し始めた月のカラム
      row_top_of_rent_section = 18 # 家賃関連の行の最初

      Slack.configure do |conf|
        conf.token = ENV['SLACK_API_TOKEN']
      end

      beginning_date = Time.new(2018, 11)
      month_diff = ((Time.now.year - beginning_date.year) * 12) + (Time.now.month - beginning_date.month)
      message = "【家賃支払い状況】\n"

      (row_top_of_rent_section..(row_top_of_rent_section + (total_member_count - 1))).each do |row|
        message << "#{worksheet[row, column_member_name]} : "
        message << "#{worksheet[row, column_beginning_month + month_diff].blank? ? '未払い' : '済'}\n"
      end

      message
    end
  end
end

PostMessage.run