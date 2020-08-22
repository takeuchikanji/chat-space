FactoryBot.define do
  factory :message do
    content {Faker::Games::Pokemon.name}
    image {File.open("#{Rails.root}/public/images/orange.jpg")}
    user
    group
  end
end