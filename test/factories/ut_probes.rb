# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ut_probe do
    angle 1
    serial "MyString"
    frequency 1
    type ""
    ref 1
    ultrasonic_id 1
  end
end
