# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :et do
    equipment "MyString"
    serial "MyString"
    calibration_due "2012-06-28"
    coating "MyString"
    calibration_block "MyString"
  end
end
