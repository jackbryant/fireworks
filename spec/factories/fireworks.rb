# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :firework do
    name "MyString"
    duration 1
    delay 1
    colour 1
  end
end
