require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  context 'change the best field' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, best: false, question: question, user: user) }
    let!(:answer1) { create(:answer, best: true, question: question, user: user) }
    it 'set best' do
      answer.update_best
      expect(answer.reload.best).to eq true
      expect(answer1.reload.best).to eq false
    end
    it 'unset best' do
      answer1.update_best
      expect(answer.best).to eq false
      expect(answer1.best).to eq false
    end
  end
end
