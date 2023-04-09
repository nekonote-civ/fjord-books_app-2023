# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true

  validates :content, presence: true

  def created_by?(current_user_id)
    current_user_id == user_id
  end
end
