# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
MiniGame.create(key: 'golden_gauntlet', name: 'golden_gauntlet', enabled: true)
MiniGame.create(key: 'nugget_blast', name: 'nugget_blast', enabled: true)

Admin.create(email: 'admin@arcade.com', password: '123qwe', password_confirmation: '123qwe')
