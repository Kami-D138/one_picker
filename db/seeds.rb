# ジャンル作成
genres = ["和食","洋食","中華料理","韓国朝鮮料理","エスニック料理","その他"]
genres.each do |genre|
    Genre.create!(name: genre)
end

sub_genres = ["ごはん・麺・パン","メイン","サイド","スープ","サラダ","デザート","その他"]
sub_genres.each do |sub_genre|
    SubGenre.create!(name: sub_genre)
end

# ユーザ作成
User.create!(name:  "admin",
    email: "sample@sample.com",
    password:              "123456",
    password_confirmation: "123456",
    admin: true )

29.times do |n|
    name  = Faker::Name.name
    email = "sample-#{n+1}@sample.com"
    password = "password"
    User.create!(name:  name,
                    email: email,
                    password:              password,
                    password_confirmation: password)
end

# ユーザ毎の偽料理データ作成
users = User.all
genre_num = (1..6).to_a
sub_genre_num = (1..7).to_a
random_num = (1..10).to_a
users.each do |user|
    random_product = random_num.sample * random_num.sample
    random_product.times do
        genre_id = genre_num.sample
        sub_genre_id = sub_genre_num.sample
        name  = Faker::Food.sushi
        memo = Faker::Food.description
        user.menus.create!(name:  name,
                        genre_id: genre_id,
                        sub_genre_id:  sub_genre_id,
                        memo: memo)
    end

    menus = user.menus.all
    menus.each do |menu|
        random_num.sample.times do
            item  = Faker::Food.ingredient
            quantity = Faker::Food.measurement
            menu.ingredients.create!(item: item, quantity: quantity)
        end

        random_num.sample.times do
            step  = Faker::Verb.ing_form
            menu.preparations.create!(step: step)
        end
    end
end