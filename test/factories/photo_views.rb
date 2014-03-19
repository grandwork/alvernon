# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :photo_view do
    part_tested "MyString"
    location "MyString"
    position "MyString"
    magnification "MyString"
  end
end
