require 'rails_helper'

describe 'Answers API' do

  describe 'GET /show' do

    let!(:answer) { create(:answer, question: create(:question)) }
    let(:http_req) {"/api/v1/answers/#{answer.id}" }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:answer) { create(:answer) }
      let!(:attachment_answer) { create(:attachment, attachable: answer) }
      let!(:comment_answer) { create(:comment, commentable: answer, user_id: user.id) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like 'should return success'

      %w(id body created_at updated_at).each do |attr|
        it "answer has: #{attr} " do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      %w(id body).each do |attr|
        it "comment has: #{attr} " do
          expect(response.body).to be_json_eql(comment_answer.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
        end
      end

      %w(id file).each do |attr|
        it "attachment has: #{attr} " do
          expect(response.body).to be_json_eql(attachment_answer.send(attr.to_sym).to_json).at_path("answer/attachments/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /create' do

    let!(:question) { create(:question) }
    let(:http_req) { "/api/v1/questions/#{question.id}/answers" }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { post "/api/v1/questions/#{question.id}/answers", format: :json, answer: {body: 'new answer'}, access_token: access_token.token }

      it_behaves_like 'should return success'

      it 'answer saved with same attr' do
        expect do
          post "/api/v1/questions/#{question.id}/answers", format: :json, answer: {body: 'new answer'}, access_token: access_token.token
        end.to change(Answer, :count).by(1)
        expect(Answer.first.body).to eq 'new answer'
      end
    end
  end
  def do_request(options={})
    get http_req, {format: :json}.merge(options)
  end
end
