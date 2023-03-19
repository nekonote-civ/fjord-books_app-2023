# frozen_string_literal: true

module ReportsHelper
  def created_by?(report_user_id)
    current_user.id == report_user_id
  end
end
