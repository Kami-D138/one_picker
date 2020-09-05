class RakutenapiController < ApplicationController
    # ランダム機能の要
    def random_number
        @random_num = [0,1,2,3].sample
    end

    # カテゴリIDをランダムでピックアップ
    def category_id_selecter
        rakuten_api_url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426?format=json&categoryType=large&elements=categoryId&applicationId=#{ENV["RAKUTEN_APPLICATION_ID"]}"
        rakuten_api_uri = URI.parse(rakuten_api_url)
        responce = Net::HTTP.get(rakuten_api_uri)
        categories_id = JSON.parse(responce)
        @category_id = categories_id["result"]["large"].sample.values
    end

    # ピックアップされたIDを元にレシピを取得
    def rakuten_recipes_selecter
        category_id_selecter
        @category_id.each do |id|
            rakuten_api_url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&elements=recipeTitle%2CrecipeMaterial%2CrecipeUrl%2CfoodImageUrl%2CrecipeDescription%2Cnickname&categoryId=#{id}&formatVersion=%EF%BC%92&applicationId=#{ENV["RAKUTEN_APPLICATION_ID"]}"
            rakuten_api_uri = URI.parse(rakuten_api_url)
            responce = Net::HTTP.get(rakuten_api_uri)
            @rakuten_recipes = JSON.parse(responce)
        end
    end

    # 4つのレシピからランダムに1つ取得
    def rakuten_recipe_set
        random_number
        rakuten_recipes_selecter
        @rakuten_recipe_person = @rakuten_recipes["result"][@random_num]["nickname"]
        @rakuten_recipe_img = @rakuten_recipes["result"][@random_num]["foodImageUrl"]
        @rakuten_recipe_title = @rakuten_recipes["result"][@random_num]["recipeTitle"]
        @rakuten_recipe_items = @rakuten_recipes["result"][@random_num]["recipeMaterial"]
        @rakuten_recipe_memo = @rakuten_recipes["result"][@random_num]["recipeDescription"]
        @rakuten_recipe_url = @rakuten_recipes["result"][@random_num]["recipeUrl"]
    end

end