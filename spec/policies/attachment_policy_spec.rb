require 'rails_helper'

describe AttachmentPolicy do

  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let(:answer) { create(:answer, question: question, user: user) }
  let(:attach_to_question) { create(:attachment, attachable: question) }
  let(:attach_to_answer) { create(:attachment, attachable: answer) }
  let(:other_user) { create(:user) }
  let(:other_question) { create(:question, user: other_user) }
  let(:other_answer) { create(:answer, question: question, user: other_user) }

  subject { described_class }

  permissions :destroy? do
    it 'authorized user can destroy his attachment' do
      expect(subject).to permit(user, attach_to_answer)
      expect(subject).to permit(user, attach_to_question)
    end
    it 'authorized user can not destroy the attachment owned by other user' do
      expect(subject).to_not permit(user, create(:attachment, attachable: other_answer))
      expect(subject).to_not permit(user, create(:attachment, attachable: other_question))
    end
    it 'non authorized user can not destroy attachment' do
      expect(subject).to_not permit(nil, attach_to_question)
      expect(subject).to_not permit(nil, attach_to_answer)
    end
  end
end
