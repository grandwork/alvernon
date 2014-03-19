# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :radiographic do
    equipment "MyString"
    film_type "MyString"
    lead_thickness "MyString"
    density "MyString"
    sensitivity "MyString"
    sfd_ffd "MyString"
    technique "MyString"
    source_size "MyString"
    iqi_type "MyString"
    iqi_position "MyString"
    exposure_data "MyString"
  end
end
