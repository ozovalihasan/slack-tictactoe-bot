require_relative '../lib/bot'

describe Bot do
  describe '#new_game' do
    it 'returns array with detail information' do
      p
      expect(Bot.new_game('Why?')).to eql[{
        color: '#5DFF00',
        title: 'Why?',
        callback_id: 'play:start',
        actions: [{
          name: 'start',
          text: '   YES   ',
          type: 'button',
          value: 'play:start'
        }]
      },
                                          { color: '#FF0000',
                                            title: '',
                                            callback_id: 'play:finish',
                                            actions: [{
                                              name: 'start',
                                              text: '   NO   ',
                                              type: 'button',
                                              value: 'play:finish'
                                            }] }]
    end
  end
end

describe Bot do
  describe '#new_game' do
    it 'returns array with detail information' do
      p Bot.intro('1')
      # expect(Bot.new_game('Why?')).to eql
    end
  end
end
