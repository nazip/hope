require 'rails_helper'

describe 'Questions API' do

  describe 'GET /index' do

    context 'unauthorized' do
      it 'without token -> return 401' do
        get '/api/v1/questions', format: :json
        expect(response.status).to eq 401
      end
      it 'invalid token -> return 401' do
        get '/api/v1/questions', format: :json, access_token: '111'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it 'return 200' do
        expect(response).to be_success
      end

      it 'return questions array' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question has: #{attr} " do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      # it 'question has short_title attribute' do
      #   expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      # end

      # context 'Answers' do
      #   it 'included into the question object' do
      #     expect(response.body).to have_json_size(1).at_path("questions/0/answers")
      #   end

      #   %w(id body created_at updated_at).each do |attr|
      #     it "answer has: #{attr} " do
      #       expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
      #     end
      #   end
      # end
    end
  end

  describe 'GET /show' do

    context 'unauthorized' do
      let!(:question) { create(:question) }
      it 'without token -> return 401' do
        get "/api/v1/questions/#{question.id}", format: :json
        expect(response.status).to eq 401
      end
      it 'invalid token -> return 401' do
        get "/api/v1/questions/#{question.id}", format: :json, access_token: '111'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:attachment_question) { create(:attachment, attachable: question) }
      let!(:comment_question) { create(:comment, commentable: question, user_id: user.id) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get "/api/v1/questions/#{question.id}", format: :json, access_token: access_token.token }

      it 'return 200' do
        expect(response).to be_success
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question has: #{attr} " do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      %w(id body).each do |attr|
        it "comment has: #{attr} " do
          expect(response.body).to be_json_eql(comment_question.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
        end
      end

      %w(id file).each do |attr|
        it "attachment has: #{attr} " do
          expect(response.body).to be_json_eql(attachment_question.send(attr.to_sym).to_json).at_path("question/attachments/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /answers' do

    context 'unauthorized' do
      let!(:question) { create(:question) }
      it 'without token -> return 401' do
        get "/api/v1/questions/#{question.id}/answers", format: :json
        expect(response.status).to eq 401
      end
      it 'invalid token -> return 401' do
        get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: '111'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let!(:question) { create(:question, user: user) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it 'return 200' do
        expect(response).to be_success
      end

      it 'return answers array' do
        expect(response.body).to have_json_size(2)
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer has: #{attr} " do
          expect(response.body).to be_json_eql(answers[1].send(attr.to_sym).to_json).at_path("0/#{attr}")
        end
      end
    end
  end

  describe 'GET /create' do

    context 'unauthorized' do
      it 'without token -> return 401' do
        post "/api/v1/questions", format: :json
        expect(response.status).to eq 401
      end
      it 'invalid token -> return 401' do
        post "/api/v1/questions", format: :json, access_token: '111'
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let!(:user) { create(:user) }
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      it 'return 200' do
        post "/api/v1/questions", format: :json, question: {title: 'new title', body: 'new question'}, access_token: access_token.token
        expect(response).to be_success
      end

      it 'question saved with same attr' do
        expect do
          post "/api/v1/questions", format: :json, question: {title: 'new title', body: 'new question'}, access_token: access_token.token
        end.to change(Question, :count).by(1)
        expect(Question.first.body).to eq 'new question'
      end
    end
  end
end
