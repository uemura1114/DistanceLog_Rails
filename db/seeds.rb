# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
if Rails.env == 'development'
  # (1..20).each do |i|
  #   User.create(name: "user#{i}", password: "1111", password_confirmation: "1111")
  # end

  (1..50).each do |i|
    st_lat = (36 + Random.rand / 100).to_s
    st_lng = (141 + Random.rand / 100).to_s
    ed_lat = (36 + Random.rand / 100).to_s
    ed_lng = (141 + Random.rand / 100).to_s
    user_id = Random.rand(User.all.count / 2)
    tag_count = Random.rand(Tag.all.count)
    tag_ids = Tag.all.sample(tag_count).pluck(:id).sort
    params = { :st_lat => st_lat, :st_lng => st_lng, :ed_lat => ed_lat, :ed_lng => ed_lng, :user_id => user_id , :tag_ids => tag_ids}
    params = Distance.calculate_distance(params)
    Distance.create(params)
  end

  # Tag.create([
  #   { name: '芯'},
  #   { name: 'ヒール'},
  #   { name: 'トゥ'},
  #   { name: 'テンプラ'},
  #   { name: 'ややテンプラ'},
  #   { name: 'ややトップ'},
  #   { name: 'トップ'},
  #   { name: 'ちょろ'},
  # ])

  i = Tag.all.count


end

