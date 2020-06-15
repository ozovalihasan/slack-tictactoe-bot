require_relative '../lib/bot'

describe Bot do
  describe '#new_game' do
    it 'returns array with detail information' do
      expect(Bot.send(:new_game, 'Why?')[1]).to eql(
        { color: '#FF0000',
          title: '',
          callback_id: 'play:finish',
          actions: [{
            name: 'start',
            text: '   NO   ',
            type: 'button',
            value: 'play:finish'
          }] }
      )
    end
  end
end

describe Bot do
  describe '#start_game' do
    it 'starts the game with default positions ' do
      Bot.send(:plays, 'hasan')
      expect(Bot.start_game('hasan')).to eql({ positions: [1, 2, 3, 4, 5, 6, 7, 8, 9], turn_number: 0 })
    end
  end
end

describe Bot do
  describe '#show_board' do
    it 'returns the lastest view of the board with title  ' do
      Bot.send(:plays, 'hasan')
      expect(Bot.show_board('hasan')[:text]).to eql('Please choose your position.')
      expect(Bot.show_board('hasan')[:attachments][1][:actions][1][:value]).to eql(5)
    end
  end
end

describe Bot do
  describe '#board_last' do
    it 'shows the lastest view of the board  ' do
      expect(Bot.board_last('hasan')[1][:actions][1][:value]).to eql(5)
    end
  end
end

describe Bot do
  describe '#plays' do
    it 'checks whether @plays is created or not ' do
      expect(Bot.send(:plays, 'ali')).to eql({ 'hasan' => { positions: [1, 2, 3, 4, 5, 6, 7, 8, 9], turn_number: 0 } })
    end
  end
end

describe Bot do
  describe '#update_board' do
    it 'updates the board with given position and symbol' do
      Bot.update_board('hasan', 1, 'X')
      expect(Bot.instance_variable_get(:@plays)['hasan'][:positions][0]).to eql('X')
    end
  end
end

describe Bot do
  describe '#increase_turn_number' do
    it 'increases turn number' do
      expect(Bot.send(:increase_turn_number, 'hasan')).to eql(2)
    end
  end
end

describe Bot do
  describe '#choose_position' do
    it 'chooses any number randomly if two same symbol is not on the same row, column or diagonal ' do
      expect(Bot.choose_position('hasan')).to be_between(2, 9)
    end

    it 'chooses different number if two same symbol is on the same row, column or diagonal' do
      Bot.update_board('hasan', 2, 'X')
      expect(Bot.choose_position('hasan')).to eql(3)
    end
  end
end

describe Bot do
  describe '#check_winner_draw' do
    context 'if there is no winner ' do
      it 'returns false if there is any position to play ' do
        url = 'https://hooks.slack.com/actions/1/1/1'
        msg = { 'bot_id' => '1', 'type' => 'message' }
        Bot.send(:plays, 'ali')
        Bot.start_game('tom')
        Bot.update_board('tom', 1, 'X')
        Bot.update_board('tom', 4, 'X')
        expect(Bot.check_winner_draw('tom', url, msg)).to eql(false)
      end

      it 'returns draw if there is no any position to play ' do
        url = 'https://hooks.slack.com/actions/1/1/1'
        msg = { 'bot_id' => '1', 'type' => 'message' }
        Bot.update_board('tom', 7, 'O')
        Bot.update_board('tom', 2, 'O')
        Bot.update_board('tom', 5, 'O')
        Bot.update_board('tom', 8, 'X')
        Bot.update_board('tom', 3, 'X')
        Bot.update_board('tom', 6, 'X')
        Bot.update_board('tom', 9, 'O')
        expect(Bot.check_winner_draw('tom', url, msg)).to eql('draw')
      end
    end
    context 'if there is a winner' do
      it 'returns the symbol of winner' do
        url = 'https://hooks.slack.com/actions/1/1/1'
        msg = { 'bot_id' => '1', 'type' => 'message' }
        Bot.send(:plays, 'ali')
        Bot.start_game('ali')
        Bot.update_board('ali', 1, 'X')
        Bot.update_board('ali', 2, 'X')
        Bot.update_board('ali', 3, 'X')
        expect(Bot.check_winner_draw('ali', url, msg)).to eql('X')
      end
    end
  end
end

describe Bot do
  describe '#check_positions' do
    context 'if winning or drawing conditions are checking' do
      it 'returns nil if three same symbol is not on the same row, column or diagonal' do
        expect(Bot.send(:check_positions, 'hasan', 'win')).to eql nil
      end

      it 'returns row,column or diagonal as array if three same symbol is on the same row, column or diagonal' do
        Bot.update_board('hasan', 3, 'X')
        expect(Bot.send(:check_positions, 'hasan', 'win')).to eql 'X'
      end
    end

    context 'if any number is chosen' do
      it 'returns row,column or diagonal as array if two same symbol is on the same row, column or diagonal' do
        Bot.update_board('hasan', 4, 'X')
        expect(Bot.send(:check_positions, 'hasan', 'choose').class).to eql Array
      end

      it 'returns nil if two same symbol is not on the same row, column or diagonal' do
        Bot.update_board('hasan', 7, 'X')
        expect(Bot.send(:check_positions, 'hasan', 'choose')).to eql nil
      end
    end
  end
end

describe Bot do
  describe '#check_rows' do
    context 'if any number is chosen' do
      it 'returns array if two same symbol is on the same row' do
        expect(Bot.send(:check_rows, [['X', 'X', 3]], 'choose')).to eql ['X', 'X', 3]
      end

      it 'returns nil if two same symbol is not on the same row' do
        expect(Bot.send(:check_rows, [['X', 2, 3]], 'choose')).to eql nil
      end
    end
    context 'if winning or drawing conditions are being checked' do
      it 'returns the symbol of the winner if two same symbol is on the same row' do
        expect(Bot.send(:check_rows, [%w[X X X]], 'win')).to eql 'X'
      end

      it 'returns nil if two same symbol is not on the same row' do
        expect(Bot.send(:check_rows, [['X', 2, 3]], 'win')).to eql nil
      end
    end
  end
end

describe Bot do
  describe '#all_equal?' do
    it 'returns true if all elements is same' do
      expect(Bot.send(:all_equal?, %w[X X X])).to eql true
    end

    it 'returns false if all elements is not same' do
      expect(Bot.send(:all_equal?, ['X', 'X', 3])).to eql false
    end
  end
end

describe Bot do
  describe '#any_equal?' do
    it 'returns true if any two elements are same' do
      expect(Bot.send(:any_equal?, ['X', 'X', 3])).to eql true
    end

    it 'returns false if any two elements are not same' do
      expect(Bot.send(:any_equal?, ['X', 2, 3])).to eql false
    end
  end
end

describe Bot do
  describe '#check_columns' do
    context 'if any number is chosen' do
      it 'returns array if two same symbol is on the same column' do
        expect(Bot.send(:check_columns, [['X'], ['X'], [2]], 'choose')).to eql(['X', 'X', 2])
      end

      it 'returns nil if two same symbol is not on the same column' do
        expect(Bot.send(:check_columns, [['X'], [2], [3]], 'choose')).to eql nil
      end
    end
    context 'if winning or drawing conditions are checked' do
      it 'returns the symbol of the winner if three same symbol is on the same column' do
        expect(Bot.send(:check_columns, [['X'], ['X'], ['X']], 'win')).to eql('X')
      end

      it 'returns nil if three same symbol is not on the same column' do
        expect(Bot.send(:check_columns, [['X'], [2], [3]], 'win')).to eql nil
      end
    end
  end
end

describe Bot do
  describe '#check_columns' do
    context 'if any number is chosen' do
      it 'returns array if two same symbol is on the same diagonal' do
        expect(Bot.send(:check_diagonals, [['X', 2, 3], [4, 'X', 6], [7, 8, 9]], 'choose')).to eql(['X', 'X', 9])
      end

      it 'returns nil if two same symbol is not on the same diagonal' do
        expect(Bot.send(:check_diagonals, [['X', 2, 3], [4, 5, 6], [7, 8, 9]], 'choose')).to eql nil
      end
    end
    context 'if winning or drawing conditions are checking' do
      it 'returns the symbol of winner if three same symbol is on the same diagonal' do
        expect(Bot.send(:check_diagonals, [['X', 2, 3], [4, 'X', 6], [7, 8, 'X']], 'win')).to eql('X')
      end

      it 'returns nil if hree same symbol is not on the same diagonal' do
        expect(Bot.send(:check_diagonals, [['X', 2, 3], [4, 5, 6], [7, 8, 9]], 'win')).to eql nil
      end
    end
  end
end
