# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  def created_by?(current_user_id, report_user_id)
    current_user_id == report_user_id
  end
end
