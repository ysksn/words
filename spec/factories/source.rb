FactoryBot.define do
  factory :source do
    association :host, factory: :host, strategy: :build

    crawled_at { Time.zone.local(2018, 9, 29, 15, 12, 1) }
    fragment   { nil }
    full_path  { 'http://www.sccsc.jp/' }
    path       { '/' }
    query      { nil }
    scheme     { 'http' }

    trait :has_not_crawled do
      crawled_at { nil }
    end

    trait :has_crawled_recentry do
      crawled_at { Time.current }
    end

    trait :has_crawled_long_time_go do
      crawled_at { Time.zone.local(2000, 1, 3, 1, 1, 1) }
    end
  end
end
