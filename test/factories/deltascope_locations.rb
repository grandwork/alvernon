# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :deltascope_location do
    location "MyString"
    scale "MyString"
    reading0 1.5
    reading90 1.5
    reading180 1.5
    reading270 1.5
    average 1.5
    deltascope_method_id 1
  end
end
