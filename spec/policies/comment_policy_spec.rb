require 'rails_helper'

describe CommentPolicy do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }

  subject { described_class }

  permissions :create? do
    it 'authorized user can comment to answer ' do
      expect(subject).to permit(user, Comment.new(commentable: answer))
    end
    it 'authorized user can comment to question' do
      expect(subject).to permit(user, Comment.new(commentable: question))
    end
    it 'non authorized user can not comment' do
      expect(subject).to_not permit(nil, Comment.new(commentable: question))
    end
  end
end
