# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ultrasonic do
    equipment "MyString"
    sensitivity "MyString"
    couplant "MyString"
    correction 1
  end
end
