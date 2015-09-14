require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it_behaves_like 'common for q/a'
  it { should validate_presence_of :question_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :body }

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

  describe "#answer_created" do
    context 'on create' do
      subject { build(:answer, question: question, user: user, body: 'some body') }

      it 'send email to question owner' do
        message_delivery = instance_double(ActionMailer::MessageDelivery)
        expect(SendAnswer).to receive(:send_email).with(user, subject).and_return(message_delivery)
        expect(message_delivery).to receive(:deliver_later)
        subject.save!
      end

      it "send email to the question's subscriber" do
        expect(SendAnswerToSubscribersJob).to receive(:perform_later).with(subject)
        subject.save!
      end
    end
    context 'on update' do
      it 'do not send email' do
        expect(SendAnswer).to_not receive(:send_email).with(user, subject)
        answer.update(body: 'other body')
      end
    end
  end
end
