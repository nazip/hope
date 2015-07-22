require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:elects).dependent(:destroy) }
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(140) }
  it { should accept_nested_attributes_for :attachments }

  let!(:user) { create(:user) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:elect) { create(:elect, user: user1, electable: question, election: 1) }
  let!(:elect1) { create(:elect, user: user2, electable: question, election: -1) }

  describe "#sum_elects" do
    it 'return sum elects of question' do
      expect(question.sum_elects).to eq 0
    end
  end

  describe "#elects_id" do
    it " returns the question elect's id" do
      expect(question.elects_id(user1.id)).to eq elect.id
    end
  end
end
