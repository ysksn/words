FactoryBot.define do
  factory :noun do
    source
    sequence(:word) { |n| "北海道#{n}" }
    count { [1, 2, 3, 4, 5].sample }
  end
end
