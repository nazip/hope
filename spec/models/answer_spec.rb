require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:elects).dependent(:destroy) }
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }
  it { should accept_nested_attributes_for :attachments }

  let!(:user) { create(:user) }
  let!(:user1) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, best: false, question: question, user: user) }
  let!(:answer1) { create(:answer, best: true, question: question, user: user) }
  let!(:elect) { create(:elect, user: user1, electable: answer, election: -1) }

  context 'change the best field' do

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

  describe "#sum_elects" do
    it 'return sum elects of answer' do
      expect(answer.sum_elects).to eq -1
    end
  end

  describe "#elects_id" do
    it " returns the answer elect's id" do
      expect(answer.elects_id(user1.id)).to eq elect.id
    end
  end
end
