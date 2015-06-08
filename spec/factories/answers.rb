FactoryGirl.define do
  factory :answer do
    question
    body 'MyText'
  end
  factory :invalidanswer, class: 'Answer' do
    question
    body nil
  end
end
