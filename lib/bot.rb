require 'slack-ruby-client'

class Bot # rubocop:todo Metrics/ClassLength
  def self.new_game(question) # rubocop:todo Metrics/MethodLength
    [{
      color: '#5DFF00',
      title: question,
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
  end

  def self.intro(user_id)
    # Open IM
    client = Slack::Web::Client.new
    res = client.conversations_open(users: user_id)
    # Attachment with play:start callback ID
    attachments = new_game('Do you want to start :question:')
    return if res.channel.id.nil?

    # Send message
    client.chat_postMessage(
      channel: res.channel.id,
      text: "I am tic-tac-toe bot, and I\'m here to play tic-tac-toe :x: :o: ",
      attachments: attachments.to_json
    )
  end

  def self.start_game(user_id)
    # Starts new game
    @plays[user_id] = {
      positions: [1, 2, 3, 4, 5, 6, 7, 8, 9], turn_number: 0
    }
  end

  def self.show_board(user_id)
    {
      text: 'Please choose your position.',
      attachments: board_last(user_id)
    }
  end

  def self.board_last(user_id)
    counter = 0
    attachment = []
    3.times do |row|
      attachment << {
        color: '#FFA500',
        callback_id: 'play:select_position',
        title: '',
        actions: []
      }
      3.times do
        attachment[row][:actions] << {
          name: "button#{counter + 1}",
          text: @plays[user_id][:positions][counter].to_s,
          type: 'button',
          value: @plays[user_id][:positions][counter]
        }
        counter += 1
      end
    end
    attachment
  end

  def self.plays(user_id)
    @plays ||= { user_id => nil }
  end

  # Check if user has order to handle dm
  def self.handle_direct_message(msg)
    user_id = msg['user']
    plays(user_id)
    if @plays[user_id].nil?
      intro(user_id)
    else
      client = Slack::Web::Client.new
      client.chat_postMessage(
        channel: msg['channel'],
        text: 'Let\'s keep playing the last game'
      )
    end
  end

  def self.update_board(user_id, chosen, symbol)
    # update chosen number
    @plays[user_id][:positions][chosen - 1] = symbol
    increase_turn_number(user_id)
  end

  def self.increase_turn_number(user_id)
    @plays[user_id][:turn_number] += 1
  end

  def self.choose_position(user_id)
    @purpose = 'choose'
    available_positions = check_positions(user_id)
    if available_positions.class == Array
      return available_positions.uniq.select { |item| available_positions.count(item) == 1 }[0]
    end

    @plays[user_id][:positions].select { |item| item.class == Integer }.sample
  end

  def self.check_winner_draw(user_id, url, msg)
    @purpose = 'win'
    winner = check_positions(user_id)
    turn = @plays[user_id][:turn_number]
    if (winner.class == String) || turn == 9
      msg['text'] = ':tada::trophy:  Congratulations! :x: You are winner :clap:'
      msg['text'] = ' I am winner. :cry: Sorry for you. Don\'t worry, this is only a game.' if winner == 'O'
      msg['text'] = ' No winner. This is a draw :handshake:' if turn == 9
      msg['attachments'] = new_game('Do you want to play one more game:question:')
      API.send_response(url, msg)
      @plays[user_id] = nil
      return winner if winner

      return 'draw'

    end
    false
  end

  def self.check_positions(user_id)
    board = @plays[user_id][:positions]
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
    if @purpose == 'win'
      grid.each { |row| return row.first if all_equal?(row) }
    else
      grid.each { |row| return row if any_equal?(row) && row.any? { |item| item.class == Integer } }
    end
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

  private_class_method(:new_game,
                       :intro,
                       :plays,
                       :increase_turn_number,
                       :check_positions,
                       :check_rows,
                       :all_equal?,
                       :any_equal?,
                       :check_columns,
                       :check_diagonals)
end
