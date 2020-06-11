require './bin/main'

# Initialize the app and create the API (bot) object
run Rack::Cascade.new [API]
