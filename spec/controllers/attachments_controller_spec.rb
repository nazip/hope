require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment_question) { create(:attachment, attachable: question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:attachment_answer) { create(:attachment, attachable: answer) }
  let!(:user1) { create(:user) }

  describe 'GET #destroy' do

    let(:obj) {attachment_question}
    context 'question owner' do
      before { sign_in user }
      it_behaves_like 'GET #destroy attachment'
    end

    let(:obj) {attachment_answer}
    context 'answer owner' do
      before { sign_in user }
      it_behaves_like 'GET #destroy attachment'
    end

    context 'other user' do
      before { sign_in user1 }

      it 'can not delete an attachment (question)' do
        expect do
          obj_path
        end.to_not change(Attachment, :count)
      end

      it 'can not delete an attachment (answer)' do
        expect do
          obj_path({answer_id: answer})
        end.to_not change(Attachment, :count)
      end
    end
  end
  def obj_path(option={})
    delete :destroy, {id: attachment_question, question_id: question, format: :js}.merge(option)
  end
end
