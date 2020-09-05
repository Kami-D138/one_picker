class LinebotController < RakutenapiController
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
            random_number
            if random_num <= 1
              rakuten_recipe_set
              rakuten_menu_details
              client.reply_message(event['replyToken'], picked_rakuten_recipe)
            else
              pickup_menu
              menu_details
              client.reply_message(event['replyToken'], picked_recipe)
            end
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

    def rakuten_menu_details
      @rakuten_items = ""
      @rakuten_recipe_items.each do |item|
        @rakuten_items << "・#{item}\n"
      end
    end

    def pickup_menu
      @menu = @menus.sample
      set_menu_details
    end

    def menu_details
      @items_text = ""
      @ingredients.each do |ingredient|
        @items_text << "\n・#{ingredient.item} ・・　#{ingredient.quantity}\n "
      end
      @steps_text = ""
      @preparations.each_with_index do |preparation, i|
        @steps_text << "\n#{i + 1}・#{preparation.step}\n"
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
              "size": "lg",
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
                  "text": @menu.name,
                  "size": "sm",
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
                  "size": "lg",
                  "weight": "bold",
                  "align": "start"
                },
                {
                  "type": "text",
                  "text": @items_text,
                  "size": "sm",
                  "weight": "regular",
                  "style": "normal",
                  "align": "start",
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
                  "size": "lg",
                  "weight": "bold",
                  "style": "normal",
                  "align": "start"
                },
                {
                  "type": "text",
                  "text": @steps_text,
                  "size": "sm",
                  "weight": "regular",
                  "style": "normal",
                  "decoration": "none",
                  "align": "start",
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

  def picked_rakuten_recipe
    {
      "type": "flex",
      "altText": "bubble",
      "contents":{
        "type": "bubble",
        "size": "mega",
        "direction": "ltr",
        "header": {
          "type": "box",
          "layout": "vertical",
          "contents": [
            {
              "type": "text",
              "text": "PickUPレシピ",
              "size": "lg",
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
                  "text": @rakuten_recipe_title,
                  "size": "sm",
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
              "contents":[
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
                  "type": "image",
                  "url": @rakuten_recipe_img,
                  "size": "full"
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
                  "text": "材料:",
                  "margin": "lg",
                  "size": "lg",
                  "weight": "bold",
                  "align": "start"
                },
                {
                  "type": "text",
                  "text": @rakuten_items,
                  "size": "sm",
                  "weight": "regular",
                  "style": "normal",
                  "align": "start",
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
                  "text": "お料理メモ",
                  "size": "lg",
                  "weight": "bold",
                  "style": "normal",
                  "align": "start"
                },
                {
                  "type": "text",
                  "text": @rakuten_recipe_memo,
                  "size": "sm",
                  "weight": "regular",
                  "style": "normal",
                  "decoration": "none",
                  "align": "start",
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
                  "text": "楽天レシピURL",
                  "size": "lg",
                  "weight": "bold",
                  "style": "normal",
                  "align": "start"
                },
                {
                  "type": "button",
                  "action": {
                    "type": "uri",
                    "label": "作り方はこちら",
                    "uri": @rakuten_recipe_url
                  }
                }
              ]
            },
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
