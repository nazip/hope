ThinkingSphinx::Index.define :comment, with: :active_record do
  #fileds
  indexes body
  indexes user_id, as: :author, sortable: true

  # attributes
  has created_at, updated_at
end
