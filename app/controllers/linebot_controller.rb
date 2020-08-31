class LinebotController < ApplicationController
    before_action :client

    require 'line/bot'

    protect_from_forgery :except => [:callback]

    def callback
        body = request.body.read

        signature = request.env['HTTP_X_LINE_SIGNATURE']
        unless client.validate_signature(body, signature)
        head :bad_request
        end

        events = client.parse_events_from(body)

        events.each do |event|
            case event
            when Line::Bot::Event::Message
                case event.type
                when Line::Bot::Event::MessageType::Text
                    @menus = Menu.all
                    if event.message['text'] == ("PickUp!")
                        pickup_menu
                        client.reply_message(event['replyToken'], picked_recipe)
                    else
                        client.reply_message(event['replyToken'], choices)
                    end
                end
            end
        end
        head :ok
    end

    private
        def all_menus_count
            recipe_counter = Menu.all.count
        end

        def pickup_menu
            @menu = @menus.sample
            set_menu_details
        end

        def client
            @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
            }
        end

        def choices
            {
                "type": "template",
                "altText": "あなたの『今日何作ろう?』のお手伝いをさせて下さい！",
                "template": {
                    "type": "buttons",
                    "thumbnailImageUrl": "https://bfe93cfc2da7.ngrok.io/1283079_s.jpg",
                    "imageAspectRatio": "rectangle",
                    "imageSize": "cover",
                    "imageBackgroundColor": "#FFFFFF",
                    "title": "Menu",
                    "text": "選択してください。",
                    "actions": [
                        {
                          "type": "message",
                          "label": "#{@menus.count}件のレシピからPickUp",
                          "text": "PickUp!"
                        },
                        {
                            "type": "uri",
                            "label": "Webサイトへ",
                            "uri": "https://pick-app-recipe.herokuapp.com/"
                        }
                    ]
                }
              }
        end

        def picked_recipe
            {
                "type": "text",
                "text": "本日の献立に#{@menu.name}はいかがでしょうか？"
            }
        end

end
