require 'bundler/setup'
Bundler.require
Dotenv.load '.env'
require_relative '../slack_notifier'

module GarbageNotifier
  class CreateMessage
    def self.run()
      # Google Spread Sheetに接続
      session = GoogleDrive::Session.from_config('config.json')
      worksheet = session.spreadsheet_by_key(ENV['GARBAGE_SPREADSHEET_KEY']).worksheets[0]

      Slack.configure do |conf|
        conf.token = ENV['SLACK_API_TOKEN']
      end

      beginning_date = Time.new(2019, 1)
      month_diff = ((Time.now.year - beginning_date.year) * 12) + (Time.now.month - beginning_date.month)
      message = "【ゴミ当番】\n"
      puts month_diff

      row_top_of_member_section = 2 # メンバー一覧の最初の行
      column_start = 3 # ゴミ当番表の最初の列
      total_member_count = 7 # ゴミ出し担当しうるメンバーの総数
      column_slack_name = 2

      (row_top_of_member_section..(row_top_of_member_section + (total_member_count - 1))).each do |row|
        unless worksheet[row, column_start + month_diff].empty?
          puts worksheet[row, column_slack_name]
          message << "<@#{worksheet[row, column_slack_name]}> "
        end
      end

      message << "\n
燃えるゴミの日です。\n
ゴミを袋に入れて縛った上で、黒いゴミバケツに入れてゴミ回収場所に出しましょう。"

      message
    end
  end
end