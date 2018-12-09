require 'bundler/setup'
Bundler.require
Dotenv.load '.env'

SLACK_CHANNEL = '#slack-test'.freeze
SLACK_ICON_EMOJI = ':money_mouth_face:'.freeze
SLACK_USER_NAME = '家賃回収おじさん'.freeze

# Google Spread Sheetに接続
session = GoogleDrive::Session.from_config('config.json')
worksheet = session.spreadsheet_by_key(ENV['GOOGLE_DRIVE_SPREADSHEET_KEY']).worksheets[0]

TOTAL_MEMBER_COUNT = 9
COLUMN_MEMBER_NAME = 4
# 居住し始めた月のカラム
COLUMN_BIGINNING_MONTH = 6
# 家賃関連の行の最初
ROW_TOP_OF_RENT_SECTION = 18

Slack.configure do |conf|
  conf.token = ENV['SLACK_API_TOKEN']
end

beginning_date = Time.new(2018,11)
month_diff = ((Time.now.year - beginning_date.year) * 12) + (Time.now.month - beginning_date.month)
post_message = "【家賃支払い状況】\n"

(ROW_TOP_OF_RENT_SECTION..(ROW_TOP_OF_RENT_SECTION + (TOTAL_MEMBER_COUNT - 1))).each do |row|
  post_message << "#{worksheet[row, COLUMN_MEMBER_NAME]} : #{worksheet[row, COLUMN_BIGINNING_MONTH + month_diff].blank? ? '未払い' : '済'}\n"
end

client = Slack::Web::Client.new
client.chat_postMessage(
  channel: SLACK_CHANNEL,
  text: post_message,
  icon_emoji: SLACK_ICON_EMOJI,
  username: SLACK_USER_NAME
)
