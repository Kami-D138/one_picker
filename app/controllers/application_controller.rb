class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    root_path
  end

  def set_menu_details
    @ingredients = Ingredient.where(menu_id: @menu.id)
    @preparations = Preparation.where(menu_id: @menu.id)
  end

  def set_user
    @user = User.find_by(id: params[:id])
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

  protected

  # 入力フォームからアカウント名情報をDBに保存するために追加
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

end
