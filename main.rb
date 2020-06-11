require 'sinatra/base'
require 'dotenv/load'
require 'slack-ruby-client'
require 'json'
require 'uri'
require 'net/http'
require_relative 'bot'
require_relative 'slack'
require_relative 'api'
require_relative 'events'

Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
  raise 'Missing API token' unless config.token
end
