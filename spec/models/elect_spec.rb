require 'rails_helper'

RSpec.describe Elect, type: :model do
  it { should belong_to :electable }
  it { should belong_to :user }
  it { should validate_presence_of :user_id }

  it { should validate_presence_of :election }
  it { should validate_inclusion_of(:election).in_array([-1, 1]) }
  it { should validate_presence_of :electable_type }
  it { should validate_inclusion_of(:electable_type).in_array(['Question', 'Answer']) }
  it { should validate_presence_of :user_id }
  it { should validate_uniqueness_of(:electable_id).scoped_to([:electable_type, :user_id]) }
end
