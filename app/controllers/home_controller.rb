class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:my_recipe]
  before_action :set_menus, :original_menus_count

  def top
  end

  def common_recipe
    random_number
    @head_or_tail = @num
    if @head_or_tail >= 1
      rakuten_recipe_set
    else
      @menu = Menu.all.sample
      set_menu_details
    end
  end

  def my_recipe
    @menu = current_user.menus.sample
    set_menu_details
  end


  private

    def set_menus
      @menus = Menu.all
    end

    def original_menus_count
      @original_menus = current_user.menus if user_signed_in?
    end

    # 楽天レシピランダム取得機能

    def random_number
      @num = [0,1,2,3].sample
    end

    # カテゴリIDをランダムでピックアップ
    def category_id_selecter
      url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryList/20170426?format=json&categoryType=large&elements=categoryId&applicationId=1058343409528998185"
      uri = URI.parse(url)
      responce = Net::HTTP.get(uri)
      categories_id = JSON.parse(responce)
      @category_id = categories_id["result"]["large"].sample.values
    end

    # ピックアップされたIDを元にレシピを取得
    def rakuten_recipes_selecter
      category_id_selecter
      @category_id.each do |id|
        @url = "https://app.rakuten.co.jp/services/api/Recipe/CategoryRanking/20170426?format=json&elements=recipeTitle%2CrecipeMaterial%2CrecipeUrl%2CfoodImageUrl%2CrecipeDescription%2Cnickname&categoryId=#{id}&formatVersion=%EF%BC%92&applicationId=1058343409528998185"
      end
      uri = URI.parse(@url)
      responce = Net::HTTP.get(uri)
      @rakuten_recipes = JSON.parse(responce)
    end

    # 4つのレシピからランダムに1つ取得
    def rakuten_recipe_set
      random_number
      rakuten_recipes_selecter
      @rakuten_recipe_person = @rakuten_recipes["result"][@num]["nickname"]
      @rakuten_recipe_img = @rakuten_recipes["result"][@num]["foodImageUrl"]
      @rakuten_recipe_title = @rakuten_recipes["result"][@num]["recipeTitle"]
      @rakuten_recipe_items = @rakuten_recipes["result"][@num]["recipeMaterial"]
      @rakuten_recipe_memo = @rakuten_recipes["result"][@num]["recipeDescription"]
      @rakuten_recipe_url = @rakuten_recipes["result"][@num]["recipeUrl"]
    end

end
