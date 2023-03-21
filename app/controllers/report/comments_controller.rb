# frozen_string_literal: true

class Report::CommentsController < CommentsController
  before_action :set_commentable, only: %i[create]

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end
end
