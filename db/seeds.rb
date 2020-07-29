# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

genres = ["和食","洋食","中華料理","韓国朝鮮料理","エスニック料理","その他"]
genres.each do |genre|
    Genre.create!(name: genre)
end

types = ["ごはん・麺・パン","メイン","サイド","スープ","サラダ","デザート","その他"]
types.each do |type|
    Type.create!(name: type)
end


User.create!(name:  "sample",
    email: "sample@sample.com",
    password:              "123456",
    password_confirmation: "123456",
    admin: true )

9.times do |n|
    name  = Faker::Name.name
    email = "sample-#{n+1}@sample.com"
    password = "password"
    User.create!(name:  name,
                    email: email,
                    password:              password,
                    password_confirmation: password)
end

users = User.all
genre_num = (1..6).to_a
type_num = (1..7).to_a
random_num = (1..10).to_a
users.each do |user|
    20.times do
        genre_id = genre_num.sample
        type_id = type_num.sample
        name  = Faker::Food.sushi
        memo = Faker::Food.description
        user.menus.create!(name:  name,
                        genre_id: genre_id,
                        type_id:  type_id,
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