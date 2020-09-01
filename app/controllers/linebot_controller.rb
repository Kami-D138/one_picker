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
                        menu_details
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

        def client
            @client ||= Line::Bot::Client.new { |config|
            config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
            config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
            }
        end

        def pickup_menu
            @menu = @menus.sample
            set_menu_details
        end

        def menu_details
            @menu_items = []
            @ingredients.each do |ingredient|
                @menu_items.push(ingredient.item)
            end
            @menu_steps = []
            @preparations.each do |preparation|
                @menu_steps.push(preparation.step)
            end
        end

        def choices
            {
                "type": "template",
                "altText": "あなたの『今日何作ろう?』のお手伝いをさせて下さい！",
                "template": {
                    "type": "buttons",
                    "thumbnailImageUrl": "https://pick-app-recipe.herokuapp.com/1283079_s.jpg",
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
                "type": "flex",
                "altText": "bubble",
                "contents":{
                    "type": "bubble",
                    "size": "kilo",
                    "direction": "ltr",
                    "header": {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": "PickUPレシピ",
                          "size": "xl",
                          "weight": "bold",
                          "margin": "none",
                          "style": "normal",
                          "align": "center"
                        }
                      ],
                      "height": "50px"
                    },
                    "body": {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "box",
                          "layout": "horizontal",
                          "contents": [
                            {
                              "type": "text",
                              "text": "#{@menu.name}",
                              "size": "lg",
                              "style": "italic",
                              "align": "center",
                              "decoration": "none",
                              "wrap": true,
                              "margin": "none",
                              "weight": "bold"
                            }
                          ],
                          "spacing": "none",
                          "margin": "none"
                        },
                        {
                          "type": "box",
                          "layout": "vertical",
                          "contents": [
                            {
                              "type": "spacer",
                              "size": "xl"
                            }
                          ]
                        },
                        {
                          "type": "box",
                          "layout": "vertical",
                          "contents": [
                            {
                              "type": "text",
                              "text": "材料:",
                              "margin": "lg",
                              "size": "xl",
                              "weight": "bold",
                              "align": "start"
                            },
                            {
                              "type": "text",
                              "text": "#{@menu_items}",
                              "size": "md",
                              "weight": "regular",
                              "style": "normal",
                              "align": "end",
                              "decoration": "none",
                              "wrap": true
                            }
                          ]
                        },
                        {
                          "type": "box",
                          "layout": "vertical",
                          "contents": [
                            {
                              "type": "spacer",
                              "size": "xl"
                            }
                          ]
                        },
                        {
                          "type": "box",
                          "layout": "vertical",
                          "contents": [
                            {
                              "type": "text",
                              "text": "作り方:",
                              "size": "xl",
                              "weight": "bold",
                              "style": "normal",
                              "align": "start"
                            },
                            {
                              "type": "text",
                              "text": "#{@menu_steps}",
                              "size": "md",
                              "weight": "regular",
                              "style": "normal",
                              "decoration": "none",
                              "align": "end",
                              "wrap": true
                            }
                          ]
                        },
                        {
                          "type": "box",
                          "layout": "vertical",
                          "contents": [
                            {
                              "type": "spacer",
                              "size": "xl"
                            }
                          ]
                        }
                      ]
                    },
                    "footer": {
                      "type": "box",
                      "layout": "horizontal",
                      "contents": [
                        {
                          "type": "button",
                          "action": {
                            "type": "uri",
                            "label": "Webサイトへ",
                            "uri": "https://pick-app-recipe.herokuapp.com/"
                          },
                          "style": "primary",
                          "height": "md",
                          "margin": "none"
                        }
                      ]
                    }
                }
            }
        end

end
