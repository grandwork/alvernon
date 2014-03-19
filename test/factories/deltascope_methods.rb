# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deltascope_method do
    serial "MyString"
    date "2013-05-04"
    specification "MyString"
    comments "MyText"
    destructive_id 1
    heading "MyString"
  end
end
