# Slack-tictactoe-bot

This is a capstone project in the Ruby course at [Microverse](https://www.microverse.org/) - @microverseinc . Creating bot for any platform for any purpose is the purpose of this capstone project

![tic_tac_toe_game](./assets/screenshot1.png)

![tic_tac_toe_game](./assets/screenshot2.png)

![tic_tac_toe_game](./assets/screenshot3.png)

## Built With

- Ruby
- Slack API
- ngrok
- Sinatra
- RSpec

## Description

The task is to create a bot to play tic-tac-toe game on Slack.

This project is mainly about

- Object Oriented Programming
- The [DRY rule](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)

## Setup

- Clone this repository by running `git clone https://github.com/ozovalihasan/Slack-tictactoe-bot.git`.

- Change branch to `readme`.

- Install [Bundler](https://github.com/rubygems/bundler) by running `gem install bundler`.

- Run `bundle install`.

- Create a [workspace](https://slack.com/get-started#/create) to test this app.

- Create a [Slack App](https://api.slack.com/start).

- Open `OAuth & Permissions` located under the `Features` title at the left side of page. Go to `Scopes`, add `chat:write`, `im:write` and `im:history` for `Bot Token Scopes`.
   
- Go to the top of the page. Install your app to your workspace by using `Install App to Workspace` button. If you change any setting, reinstall it.

- Go to the top of the page and copy `Bot User OAuth Access Token`.

- Open the terminal, and run `export SLACK_BOT_TOKEN=xoxb-000000000000-xxxxxxxxxxxxxxxxxxxxxxxx`. 'xoxb-000000000000-xxxxxxxxxxxxxxxxxxxxxxxx' part must be changed with token you copied.

- Open the page of app settings and click `Basic Information` at the left side of the page. Under the `App Credentials`, find `Verification Token` and copy it.

- Open the terminal, and run `export SLACK_VERIFICATION_TOKEN=xxxxxxxxxxxxxxxxxxx`. 'xxxxxxxxxxxxxxxxxxx' part must be changed with token you copied.

Reminder : If you want to share your project, don't add this informations into your project because Slack may disable your app if you share this informations with public.

- Make enable Bot user to be always online. To do it, click `App Home` under `Features` title. Check `Always Show My Bot as Online` option.

***
Steps until here are shown in [the video](https://www.loom.com/share/411ca989c06c4bf189c743cc013af810s)
*** 
- Don't forget to reinstall your app

- Run Sinatra by using `rackup` from terminal. This terminal shouldn't be closed when app is used.

- Open another terminal and run `ngrok http -host-header=rewrite 9292`. 9292 is default one, so if it is not work correctly, check terminal run `rackup`. It is seen like `Listening on tcp://localhost:9292`. Again this terminal must be open when the app is used

- When ngrok run, there should be a link similar to `https://1a2b3c4d5e.ngrok.io`. Copy this link and click 'Your apps' located at the right top of `api.slack.com`. Click your app. Click `Event Subscriptions` at the left side of page. Paste copied link into `Request URL` and add `/slack/events` at the end of link. It should be seen like `https://1a2b3c4d5e.ngrok.io/slack/events`. Open `Subscribe to bot events` part and add `message.im`. Check `Enable Events`. Lastly, click `Save Changes` at the left bottom part of the page.

- Click `Interactivity & Shortcuts` at the left side of the page. Check button of `Interactivity`. Paste same link into the box of `Request URL`. And add `/slack/attachments` at the end of the link. It should be seen like `https://1a2b3c4d5e.ngrok.io/slack/attachments`. Lastly, click `Save Changes` at the left bottom part of the page.

- If ngrok is restarted, the copied link will be changed automatically. So, you need to follow the last two steps if it is restarted.

- ngrok is accepting limited request for a limited time. So, if there will be a lot of interaction between user and bot, the responding time of the bot may increase or it may not respond the user's interaction. If this happened, ngrok can be restarted or you may stop to use the app for a while.

- Go to your Workspace. Refresh page and send a direct message to bot from Slack. It is located under the `Apps` title


***
Steps until here are shown in [the video](https://www.loom.com/share/e245f36c42df4ced94a71b1e832947e9)
*** 

- If you need more information, you may check [this repository](https://github.com/slackapi/sample-message-menus-ruby)

## How to Play the Game

- Send any direct message to the bot
- Follow the directions given by the bot

If you want, [check the demo of the app/bot](https://www.loom.com/share/ce5a36e4145c4baf96cd615a06faf9b0) 

## Rules of the Game

- The user is represented 'X' and the bot is represented 'O' as symbol
- To win the game, three identical symbols must be next to each other vertically, horizontally, or diagonally. If there is a winner, the winner will be announced as "WINNER"
- If no one has won by the end of ninth turn, the game will be ended as a "DRAW"

For more information check [Wikipedia](https://en.wikipedia.org/wiki/Tic-tac-toe)

## Testing the code

- All methods are tested

To test the project

- Open terminal
- Run `cd directory-of-project`. It must be seen like `cd Downloads/Slack-tictactoe-bot`   
- Run `rspec`


## Plans to develop the project

- Providing a live demo of the app/bot
- Providing an online server for the code
- Providing a video to show steps of setup

## Questions and answers

- The app/bot is not updated. What do I need to do?

Check Gemfile. If versions of used gems are not updated, update them.

- The app/bot doesn't respond. What do I need to do?

Check SLACK_VERIFICATION_TOKEN, SLACK_BOT_TOKEN. Check the link provided by ngrok and check the link used for 'Request URL's. Check the terminal run `rackup`. If it shows any error, solve it.

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
