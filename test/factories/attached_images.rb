# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :attached_image do
    report_id 1
    image "MyString"
    description "MyText"
  end
end
