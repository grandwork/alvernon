# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mpi do
    association :report
    equipment "Yoke"
    type_of_powder "Black ink - wet"
    current "240 V - AC"
    contrast "White pant"
    field_strength "4.5 kg min lift / 2.4-4.0kA/M"
    pole_spacing "75 - 200 mm"
  end
end
