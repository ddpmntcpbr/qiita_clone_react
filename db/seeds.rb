ActiveRecord::Base.transaction do
  20.times do |_n|
    name = Faker::Name.name
    email = "#{_n}_" + Faker::Internet.email
    password = Faker::Internet.password(min_length: 10)
    User.create!(
      name: name,
      email: email,
      password: password,
    )
  end

  100.times do
    title = Faker::Lorem.sentence
    body = Faker::Lorem.paragraph
    user_id = User.pluck(:id).sample
    Article.create!(
      title: title,
      body: body,
      user_id: user_id,
      status: "published",
    )
  end

  300.times do
    body = Faker::Lorem.paragraph
    user_ids = User.pluck(:id)
    user_id = user_ids.sample
    user_ids.delete(user_id)
    other_user_id = user_ids.sample
    article_id = Article.where(user_id: other_user_id).pluck(:id).sample
    next unless article_id

    Comment.create!(
      body: body,
      user_id: user_id,
      article_id: article_id,
    )
  end

  Article.find_each do |article|
    other_user_ids = User.where.not(id: article.user_id).pluck(:id)
    other_user_ids.each do |other_user_id|
      next unless [true, false].sample

      ArticleLike.create!(
        user_id: other_user_id,
        article: article,
      )
    end
  end
end
