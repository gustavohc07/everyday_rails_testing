FactoryBot.define do
  factory :task do
    completed false
    name 'Estudo Dirigido'
    association :project

    trait :completed_task do
      completed false
    end

    trait :not_completed_task do
      completed true
    end
  end
end
