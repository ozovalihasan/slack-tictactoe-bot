# Slack-tictactoe-bot


This is a capstone project in the Ruby course at [Microverse](https://www.microverse.org/) - @microverseinc . Creating bot for any platform for any purpose is the purpose of this capstone project


## Built With

- Ruby
- Rspec
- Slack API
- ngrok
- Sinatra

## Description

The task is to create a bot to play tic-tac-toe game on Slack.

This project is mainly about

-  Object Oriented Programming
-  The [DRY rule](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

## Setup

- Install [Bundler](https://github.com/rubygems/bundler) by running `gem install bundler` 

- Run `bundle install`

- Create a [Slack App](https://api.slack.com/start)

- Make enable Bot user to be always online

- Enable events by using `yourURL/slack/events`. ngrok is suggested. If you use it, it is seen like `https://xxxxxxxxxxx.ngrok.io/slack/events`. Create subscription for `message.im`. Save changes.

- Open 'Interactivity & Shortcuts' and change request url as `yourURL/slack/attachments`. It should be seen like `https://xxxxxxxxxxxx.ngro/slack/attachments`. Save changes. 

- Install your app to your workspace. If you change any setting, reinstall it. 

- Create .env file and add 
```
SLACK_VERIFICATION_TOKEN=xxxxxxxxxxxxxxxxxxx
SLACK_BOT_TOKEN=xoxb-000000000000-xxxxxxxxxxxxxxxxxxxxxxxx
```
If you share your project, don't add this file into your project because Slack may disable your app if you share this informations with public

If this file don't work properly, all of them can be added one-by-one by using `export SLACK_VERIFICATION_TOKEN=xxxxxxxxxxxxxxxxxxx` from the terminal.

- Run sinatra by using `rackup` from terminal. This terminal shouldn't be closed when app is used

- Open another terminal and run `ngrok http -host-header=rewrite 9292`. 9292 is default one, so if it is not work correctly, check terminal run `rackup`. It is seen like `Listening on tcp://localhost:9292`. Again this terminal must be open when the app is used

- Send a direct message to bot from Slack

- If you need more information, you may check [this repository](https://github.com/slackapi/sample-message-menus-ruby)

## How to Play the Game

- Send any direct message to bot
- Follow the directions given by bot


## Rules of the Game

- User is represented 'X' and bot is represented 'O' as symbol
- To win the game, three identical symbols must be next to each other vertically, horizontally, or diagonally. If there is a winner, the winner will be announced as "WINNER"
- If no one has won by the end of ninth turn, the game will be ended as a "DRAW"

For more information check [Wikipedia](https://en.wikipedia.org/wiki/Tic-tac-toe )

## Plans to develop the project

- Providing a live demo of app(bot)

## Authors

👤 **Hasan Özovalı**

- Github: [@ozovalihasan](https://github.com/ozovalihasan)
- Twitter: [@ozovalihasan](https://twitter.com/ozovalihasan)
- Linkedin: [Hasan Özovalı](https://www.linkedin.com/in/hasan-ozovali/)
- Mail: [ozovalihasan@gmail.com](ozovalihasan@gmail.com) 

## Acknowledgements

- Special thanks to contributors of [this repository](https://github.com/slackapi/sample-message-menus-ruby). 

## 📝 License

This project is [MIT](https://opensource.org/licenses/MIT) licensed.