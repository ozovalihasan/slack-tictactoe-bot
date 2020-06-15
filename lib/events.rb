class Events
  # Handle message IM event
  def self.message(_team_id, event_data)
    # Handle direct message
    Bot.handle_direct_message(event_data) if event_data['user']
  end
end
