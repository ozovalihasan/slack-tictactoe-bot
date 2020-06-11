require 'sinatra/base'
require 'net/http'

class API < Sinatra::Base
  # Send response of message to response_url
  def self.send_response(response_url, msg)
    p response_url, msg
    p '=========='
    url = URI.parse(response_url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(url)
    request['content-type'] = 'application/json'
    request.body = JSON[msg]
    p request, http
    p '----------------'
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
      # Start game callback
    when 'play:start'

      # Modify message to acknowledge
      msg = request_data['original_message']
      msg['text'] = ':video_game: OK I\'m starting the game.'
      msg['attachments'] = []
      API.send_response(url, msg)
      Bot.start_game(request_data['user']['id'], url)
      # Select type callback
    when 'play:select_position'

      loop do
        user_id = request_data['user']['id']
        msg = request_data['original_message']
        chosen = request_data['actions'][0]['value'].to_i
        if chosen.zero?
          Bot.start_game(user_id, url)
          break
        end
        Bot.update_board(request_data, chosen, 'X')
        break if Bot.check_winner_draw(user_id, url, msg)

        msg['text'] = ' It is my turn.'
        msg['attachments'] = Bot.board_last(user_id)
        API.send_response(url, msg)
        sleep(1)
        chosen = Bot.choose_position(user_id)
        msg['text'] = "I\'m chosing #{chosen}."
        API.send_response(url, msg)
        Bot.update_board(request_data, chosen, 'O')
        sleep(1)

        break if Bot.check_winner_draw(user_id, url, msg)

        Bot.start_game(user_id, url)
        break
      end
      # Select option callback
    when 'play:finish'
      user_id = request_data['user']['id']
      msg = request_data['original_message']
      msg['text'] = ':ok: If you want to play more, I will be here. Only send any message to me '
      msg['attachments'] = []
      API.send_response(url, msg)
      client = Slack::Web::Client.new
      client.conversations_close(user: user_id)

    end
    status 200
  end
end
