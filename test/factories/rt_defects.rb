# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :rt_defect do
    part_number "MyString"
    welder "MyString"
    area "MyString"
    films "MyString"
    accept_reject "MyString"
    defect_type "MyString"
    length "MyString"
    location "MyString"
    radiographic_id 1
  end
end
