require_relative '../lib/api'

describe API do
  describe '#send_response' do
    it 'returns whether given url is found or not' do
      url = 'https://hooks.slack.com/actions/T/1/X'
      msg = { 'bot_id' => 'B', 'type' => 'message', 'attachments' => [] }
      # expect(API.send_response(url, msg).class).to eql(Net::HTTPTooManyRequests)
      expect([Net::HTTPTooManyRequests, Net::HTTPNotFound].include?(API.send_response(url, msg).class)).to eql(true)
    end
  end
end
