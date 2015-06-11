FactoryGirl.define do
  factory :answer do
    user
    question
    body 'MyAnswer'
  end
  factory :invalidanswer, class: 'Answer' do
    user
    question
    body nil
  end
end
