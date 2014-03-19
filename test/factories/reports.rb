# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :report do
    client "Keppel Norway AS"
    location "Dusavik"
    title "Welding Procedure Qualification, 2pcs"
    date "01.12.2011"
    procedure "APP - QP - 07"
    code "ISO 5817"
    description "Procedure description"
  end
end
