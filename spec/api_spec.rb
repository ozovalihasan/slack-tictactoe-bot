require_relative '../lib/api'

describe API do
  describe '#send_response' do
    it 'returns whether given url is found or not' do
      url = "https://hooks.slack.com/actions/T/1/X"
      msg = {"bot_id"=>"B", "type"=>"message", "text"=>":video_game: OK I'm starting the game.", "user"=>"U015PS338F3", "ts"=>"1592039459.003000", "team"=>"T015DGYLZKN", "bot_profile"=>{"id"=>"B015BDVUDDZ", "deleted"=>false, "name"=>"ttt", "updated"=>1591976654, "app_id"=>"A0159RYKKGD", "icons"=>{"image_36"=>"https://a.slack-edge.com/80588/img/plugins/app/bot_36.png", "image_48"=>"https://a.slack-edge.com/80588/img/plugins/app/bot_48.png", "image_72"=>"https://a.slack-edge.com/80588/img/plugins/app/service_72.png"}, "team_id"=>"T015DGYLZKN"}, "attachments"=>[]}
      expect(API.send_response(url, msg).class).to eql(Net::HTTPNotFound)
    end
  end
end
