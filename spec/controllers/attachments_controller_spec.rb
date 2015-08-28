require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:attachment_question) { create(:attachment, attachable: question) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:attachment_answer) { create(:attachment, attachable: answer) }
  let!(:user1) { create(:user) }

  describe 'GET #destroy' do
    context 'question owner' do
      before { sign_in user }

      it 'deletes attachment' do
        expect do
          delete :destroy,
                 id: attachment_question,
                 question_id: question,
                 format: :js
        end.to change(Attachment, :count).by(-1)
      end
      it 'render the template destroy' do
        delete :destroy, id: attachment_question, question_id: question, format: :js
        expect(response).to render_template 'attachments/destroy'
      end
    end
    context 'answer owner' do
      before { sign_in user }

      it 'deletes attachment' do
        expect do
          delete :destroy,
                 id: attachment_answer,
                 question_id: question,
                 answer_id: answer,
                 format: :js
        end.to change(Attachment, :count).by(-1)
      end
      it 'render the template destroy' do
        delete :destroy, id: attachment_answer, question_id: question, answer_id: answer, format: :js
        expect(response).to render_template 'attachments/destroy'
      end
    end

    context 'other user' do
      before { sign_in user1 }

      it 'can not delete an attachment (question)' do
        expect do
          delete :destroy,
                 id: attachment_question,
                 question_id: question,
                 format: :js
        end.to_not change(Attachment, :count)
      end

      it 'can not delete an attachment (answer)' do
        expect do
          delete :destroy,
                 id: attachment_answer,
                 question_id: question,
                 answer_id: answer,
                 format: :js
        end.to_not change(Attachment, :count)
      end
    end
  end
end
