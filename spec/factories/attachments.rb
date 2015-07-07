FactoryGirl.define do
  factory :attachment do
    file { File.new(Rails.root.join('spec', 'rails_helper.rb')) }
  end
  factory :attachment1, class: Attachment do
    file { File.new(Rails.root.join('spec', 'spec_helper.rb')) }
  end
end
