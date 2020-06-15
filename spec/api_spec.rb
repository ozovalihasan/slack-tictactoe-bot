require_relative '../lib/api'

describe API do
  describe '#send_response' do
    it 'returns whether given url is found or not' do
      url = "https://hooks.slack.com/actions/T/1/X"
      msg = {"bot_id"=>"B", "type"=>"message", "text"=>":video_game: OK I'm starting the game.", "user"=>"1", "ts"=>"1", "team"=>"1", "bot_profile"=>{"id"=>"1", "deleted"=>false, "name"=>"ttt", "updated"=>1, "app_id"=>"1", "icons"=>{"image_36"=>"https://a.slack-edge.com/80588/img/plugins/app/bot_36.png", "image_48"=>"https://a.slack-edge.com/80588/img/plugins/app/bot_48.png", "image_72"=>"https://a.slack-edge.com/80588/img/plugins/app/service_72.png"}, "team_id"=>"1"}, "attachments"=>[]}
      # expect(API.send_response(url, msg).class).to eql(Net::HTTPTooManyRequests)
      p (API.send_response(url, msg).class)
      expect((API.send_response(url, msg).class) == (Net::HTTPTooManyRequests) || (API.send_response(url, msg).class == (Net::HTTPNotFound) )).to eql(true)
    end
  end
end
