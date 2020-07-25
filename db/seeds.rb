# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "sample",
    email: "sample@sample.com",
    password:              "123456",
    password_confirmation: "123456")

genres = ["日本料理","韓国料理","中華料理","フランス料理","イタリア料理","スペイン料理","その他"]
genres.each do |genre|
    Genre.create!(name: genre)
end

types = ["メイン","サイド","スープ","サラダ","デザート","その他"]
types.each do |type|
    Type.create!(name: type)
end
