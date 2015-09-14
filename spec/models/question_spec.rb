require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it_behaves_like 'common for q/a'
  it { should belong_to :user }
  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should validate_presence_of :user_id }
  it { should validate_length_of(:body).is_at_least(5).is_at_most(140) }

  let!(:user) { create(:user) }
  let!(:user1) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:elect) { create(:elect, user: user1, electable: question, election: 1) }
  let!(:elect1) { create(:elect, user: user2, electable: question, election: -1) }
  let!(:old_question) { create(:question, created_at: Time.now - 2.day, user: user) }

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

  describe "scope :today_created" do
    it " should return the today's questions " do
      expect(Question.today_created.count).to eq 1
    end
  end

end
