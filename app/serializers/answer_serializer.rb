class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :user_id, :question_id, :created_at, :updated_at, :best

  has_many :comments
  has_many :links
  has_many :files, serializer: AttachmentSerializer
  belongs_to :user
end
