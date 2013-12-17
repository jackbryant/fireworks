# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :show do
    name "MyString"
    track_url "MyURL"
    id 999
  end
end
