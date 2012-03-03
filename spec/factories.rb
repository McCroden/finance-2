FactoryGirl.define do

  factory :user do
    sequence(:email) {|n| "person#{n}@example.com"}
    password { 123456 }
  end

  factory :stock do
    user
    symbol { 'AAPL' }
    shares { 100 }
    price  { 50 }
  end

  factory :market_price do
    symbol { 'AAPL' }
    price  { 80 }
  end

end
