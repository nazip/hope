class QuestionCommentsSerializer < ActiveModel::Serializer
  attributes :id #, :title, :body #, :created_at, :updated_at

  # has_many :attachments
  # include Commentable
end
