require 'sinatra/base'
require 'dotenv/load'
require 'slack-ruby-client'
require 'json'
require 'uri'
require 'net/http'
require_relative '../lib/bot'
require_relative '../lib/api'

Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
  raise 'Missing API token' unless config.token
end
