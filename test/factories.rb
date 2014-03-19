FactoryGirl.define do
  factory(:user) do
    sequence(:email) {|n| "jane.doe#{n}@csindi.com"}
    password "secret"
  end
  
  factory :admin, :class => User do
    sequence(:email) {|n| "admin.admin#{n}@csindi.com" }
    password "secret"
    admin true
  end 
end