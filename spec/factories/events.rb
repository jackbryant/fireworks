# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    start "MyString"
    'end' "MyString"
    content "MyString"
    show_id "999"
    delay '0'
  end
end
