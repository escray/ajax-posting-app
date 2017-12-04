namespace :dev do
  task fake: :environment do
    users = []
    50.times do
      users << User.create!(email: Faker::Internet.email, password: '12345678')
    end

    150.times do |_i|
      Post.create!(content: Faker::Lorem.paragraph,
                   user_id: users.sample.id)
    end
  end
end
