require 'sinatra/base'
require 'dotenv/load'
require 'slack-ruby-client'
require 'json'
require 'uri'
require 'net/http'

module Slack
  module Web
    class Client
      include Api::Endpoints::Conversations
    end
  end
end

Slack.configure do |config|
  config.token = ENV['SLACK_BOT_TOKEN']
  raise 'Missing API token' unless config.token
end


# Plays object
$plays = {}

class API < Sinatra::Base
  # Send response of message to response_url
  def self.send_response(response_url, msg)
    url = URI.parse(response_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request['content-type'] = 'application/json'
    request.body = JSON[msg]
    http.request(request)
  end

  post '/slack/events' do
    request_data = JSON.parse(request.body.read)

    case request_data['type']
    when 'url_verification'
      # URL Verification event with challenge parameter
      request_data['challenge']
    when 'event_callback'
      # Verify requests
      return if request_data['token'] != ENV['SLACK_VERIFICATION_TOKEN']

      team_id = request_data['team_id']
      event_data = request_data['event']
      case event_data['type']
        # Message IM event
      when 'message'
        return if event_data['subtype'] == 'bot_message' || event_data['subtype'] == 'message_changed'

        Events.message(team_id, event_data)
      else
        puts "Unexpected events\n"
      end
      status 200
    end
  end

  post '/slack/attachments' do
    request.body.rewind
    request_data = request.body.read

    # Convert
    request_data = URI.decode_www_form_component(request_data, Encoding::UTF_8)

    # Parse and remove "payload=" from beginning of string
    request_data = JSON.parse(request_data.sub!('payload=', ''))
    url = request_data['response_url']

    case request_data['callback_id']
      # Start order callback
    when 'play:start'
      # Modify message to acknowledge
      msg = request_data['original_message']
      msg['text'] = ':video_game: OK I\'m starting the game.'
      msg['attachments'] = []
      API.send_response(url, msg)
      Bot.start_game(request_data['user']['id'], request_data['original_message'], url)
      # Select type callback
    when 'play:select_position'

      begin
        user_id = request_data['user']['id']
        msg = request_data['original_message']
        chosen = request_data['actions'][0]['value'].to_i
        if chosen.zero?
          Bot.start_game(user_id, request_data['original_message'], url)
          break
        end
        Bot.update_board(request_data, chosen, 'X')
        break if Bot.check_winner_draw(user_id, url, msg)

        if $plays[user_id][:turn_number] < 9
          msg['text'] = ' It is my turn.'
          msg['attachments'] = Bot.board_last(user_id)
          API.send_response(url, msg)
        end
        sleep(1)

        chosen = Bot.choose_position(user_id)
        msg['text'] = "I\'m chosing #{chosen}."
        API.send_response(url, msg)
        Bot.update_board(request_data, chosen, 'O')
        sleep(1)

        break if Bot.check_winner_draw(user_id, url, msg)

        Bot.start_game(user_id, request_data['original_message'], url)
      end while false

      # Select option callback
    when 'play:finish'
      msg = request_data['original_message']
      msg['text'] = ':ok: If you want to play more, I will be here. Only send any message to me '
      msg['attachments'] = []
      API.send_response(url, msg)
      client = Slack::Web::Client.new
      client.conversations_close(users: user_id)

    end
    status 200
  end
end

class Events
  # Handle message IM event
  def self.message(_team_id, event_data)
    # Handle direct message
    Bot.handle_direct_message(event_data) if event_data['user']
  end
end

class Bot
  def self.intro(user_id)
    # Open IM
    client = Slack::Web::Client.new
    res = client.conversations_open(users: user_id)
    # Attachment with play:start callback ID
    attachments = [{
      color: '#5DFF00',
      title: 'Do you want to start :question:',
      callback_id: 'play:start',
      actions: [
        {
          name: 'start',
          text: '   YES   ',
          type: 'button',
          value: 'play:start'
        }
      ]
    },
                   {
                     color: '#FF0000',
                     title: '',
                     callback_id: 'play:finish',
                     actions: [
                       {
                         name: 'start',
                         text: '   NO   ',
                         type: 'button',
                         value: 'play:finish'
                       }
                     ]
                   }]
    unless res.channel.id.nil?
      # Send message
      client.chat_postMessage(
        channel: res.channel.id,
        text: "I am tic-tac-toe bot, and I\'m here to play tic-tac-toe :x: :o: ",
        attachments: attachments.to_json
      )
    end
  end

  def self.start_game(user_id, msg, url)
    # Check if game already exists
    if $plays[user_id].nil?
      # Starts new game
      $plays[user_id] = {
        positions: [1, 2, 3, 4, 5, 6, 7, 8, 9], turn_number: 0
      }

    end
    # Sends menu with play:select_position callback
    msg = {
      text: 'Please choose your position?',
      attachments: board_last(user_id)
    }
    # Send message
    API.send_response(url, msg)
  end

  def self.board_last(user_id)
    [{
      color: '#FFA500',
      callback_id: 'play:select_position',
      text: '',
      actions: [
        {
          name: 'start',
          text: $plays[user_id][:positions][0].to_s,
          type: 'button',
          value: $plays[user_id][:positions][0]
        },
        {
          name: 'start',
          text: $plays[user_id][:positions][1].to_s,
          type: 'button',
          value: $plays[user_id][:positions][1]
        },
        {
          name: 'start',
          text: $plays[user_id][:positions][2].to_s,
          type: 'button',
          value: $plays[user_id][:positions][2]
        }
      ]
    }, {
      color: '#FFA500',
      title: '',
      callback_id: 'play:select_position',
      actions: [
        {
          name: 'start',
          text: $plays[user_id][:positions][3].to_s,
          type: 'button',
          value: $plays[user_id][:positions][3]
        },
        {
          name: 'start',
          text: $plays[user_id][:positions][4].to_s,
          type: 'button',
          value: $plays[user_id][:positions][4]
        },
        {
          name: 'start',
          text: $plays[user_id][:positions][5].to_s,
          type: 'button',
          value: $plays[user_id][:positions][5]
        }
      ]
    }, {
      color: '#FFA500',
      title: '',
      callback_id: 'play:select_position',
      actions: [
        {
          name: 'start',
          text: $plays[user_id][:positions][6].to_s,
          type: 'button',
          value: $plays[user_id][:positions][6]
        },
        {
          name: 'start',
          text: $plays[user_id][:positions][7].to_s,
          type: 'button',
          value: $plays[user_id][:positions][7]
        },
        {
          name: 'start',
          text: $plays[user_id][:positions][8].to_s,
          type: 'button',
          value: $plays[user_id][:positions][8]
        }
      ]
    }]
  end

  # Check if user has order to handle dm
  def self.handle_direct_message(msg)
    user = msg['user']
    if $plays[user].nil?
      intro(user)
    else
      client = Slack::Web::Client.new
      client.chat_postMessage(
        channel: msg['channel'],
        text: 'Let\'s keep playing the last game'
      )
    end
  end

  def self.update_board(request_data, chosen, symbol)
    user_id = request_data['user']['id']
    # update chosen number
    $plays[user_id][:positions][chosen - 1] = symbol
    increase_turn_number(user_id)
  end

  def self.increase_turn_number(user_id)
    $plays[user_id][:turn_number] += 1
  end

  def self.choose_position(user_id)
    available_positions = check_positions(user_id)
    if available_positions.class == Array
      return available_positions.uniq.select { |item| available_positions.count(item) == 1 }[0]
    end

    $plays[user_id][:positions].select { |item| item.class == Integer }.sample
  end

  def self.check_winner_draw(user_id, url, msg)
    winner = check_positions(user_id)
    turn = $plays[user_id][:turn_number]
    p turn
    p '============='
    if (winner.class == String) || turn == 9
      msg['text'] = ':tada::trophy:  Congratulations! :x: You are winner :clap:' if winner == 'X'
      msg['text'] = ' I am winner. :cry: Sorry for you. Don\'t worry, this is only a game.' if winner == 'O'
      msg['text'] = ' No winner. This is a draw :handshake:' if turn == 9

      msg['attachments'] = [{
        color: '#5DFF00',
        title: 'Do you want to play one more game:question:',
        callback_id: 'play:start',
        actions: [
          {
            name: 'start',
            text: '   YES   ',
            type: 'button',
            value: 'play:start'
          }

        ]
      }, {
        color: '#FF0000',
        title: '',
        callback_id: 'play:finish',
        actions: [
          {
            name: 'start',
            text: '   NO   ',
            type: 'button',
            value: 'play:finish'
          }
        ]
      }]

      API.send_response(url, msg)
      $plays[user_id] = nil
      return winner
    end
    false
  end

  def self.check_positions(user_id)
    board = $plays[user_id][:positions]
    grid = [
      [board[0], board[1], board[2]],
      [board[3], board[4], board[5]],
      [board[6], board[7], board[8]]
    ]
    # check the rows
    return check_rows(grid) unless check_rows(grid).nil?

    # check the columns
    return check_columns(grid) unless check_columns(grid).nil?

    # check the diagonals
    return check_diagonals(grid) unless check_diagonals(grid).nil?

    nil
  end

  def self.check_rows(grid)
    grid.each { |row| return row.first if all_equal?(row) }
    grid.each { |row| return row if any_equal?(row) && row.any? { |item| item.class == Integer } }

    nil
  end

  def self.all_equal?(row)
    row.each_cons(2).all? { |x, y| x == y }
  end

  def self.any_equal?(row)
    row.each_cons(2).any? { |x, y| x == y }
  end

  def self.check_columns(grid)
    check_rows(grid.transpose)
  end

  def self.check_diagonals(grid)
    diagonals = [
      [grid[0][0], grid[1][1], grid[2][2]],
      [grid[2][0], grid[1][1], grid[2][0]]
    ]
    check_rows(diagonals)
  end
end
