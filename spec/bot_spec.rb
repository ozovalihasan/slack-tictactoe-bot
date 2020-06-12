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
  describe '#intro' do
    it 'shows a window to user to start the game' do
      # Test is not possible
      # because connecting to Slack is necessary to test it
      # Any way for testing the method is not known
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
  describe '#handle_direct_message' do
    it 'sends direct message to user' do
      # Test is not possible
      # because connecting to Slack is necessary to test it
      # Any way for testing the method is not known
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
    it '' do
      # Test is not possible
      # because connecting to Slack is necessary to test it
      # Any way for testing the method is not known
    end
  end
end

describe Bot do
  describe '#check_positions' do
    context 'if any number is chosen' do
      it 'returns row,column or diagonal as array if two same symbol is on the same row, column or diagonal' do
        expect(Bot.send(:check_positions, 'hasan').class).to eql Array
      end

      it 'return nil if two same symbol is not on the same row, column or diagonal' do
        Bot.update_board('hasan', 3, 'X')
        expect(Bot.send(:check_positions, 'hasan')).to eql nil
      end
    end

    context 'if winning or drawing conditions are checking' do
      # For to test this check_winner_draw method must be used
      # But it is not called without using Slack
    end
  end
end

describe Bot do
  describe '#check_rows' do
    context 'if any number is chosen' do
      it 'returns array if two same symbol is on the same row' do
        expect(Bot.send(:check_rows, [['X', 'X', 3]])).to eql ['X', 'X', 3]
      end

      it 'returns array if two same symbol is not on the same row' do
        expect(Bot.send(:check_rows, [['X', 2, 3]])).to eql nil
      end
    end
    context 'if winning or drawing conditions are checking' do
      # For to test this check_winner_draw method must be used
      # But it is not called without using Slack
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

    it 'returns true if any two elements are not same' do
      expect(Bot.send(:any_equal?, ['X', 2, 3])).to eql false
    end
  end
end

describe Bot do
  describe '#check_columns' do
    context 'if any number is chosen' do
      it 'returns array if two same symbol is on the same column' do
        expect(Bot.send(:check_columns, [['X'], ['X'], [2]])).to eql(['X', 'X', 2])
      end

      it 'returns array if two same symbol is not on the same column' do
        expect(Bot.send(:check_columns, [['X'], [2], [3]])).to eql nil
      end
    end
    context 'if winning or drawing conditions are checking' do
      # For to test this check_winner_draw method must be used
      # But it is not called without using Slack
    end
  end
end

describe Bot do
  describe '#check_columns' do
    context 'if any number is chosen' do
      it 'returns array if two same symbol is on the same diagonal' do
        expect(Bot.send(:check_diagonals, [['X', 2, 3], [4, 'X', 6], [7, 8, 9]])).to eql(['X', 'X', 9])
      end

      it 'returns array if two same symbol is not on the same diagonal' do
        expect(Bot.send(:check_diagonals, [['X', 2, 3], [4, 5, 6], [7, 8, 9]])).to eql nil
      end
    end
    context 'if winning or drawing conditions are checking' do
      # For to test this check_winner_draw method must be used
      # But it is not called without using Slack
    end
  end
end
