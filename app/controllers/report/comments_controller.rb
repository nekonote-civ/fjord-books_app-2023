# frozen_string_literal: true

class Report::CommentsController < CommentsController
  before_action :set_commentable, only: :create

  private

  def set_commentable
    @commentable = Report.find(params[:report_id])
  end

  def render_show_commentable
    @report = @commentable
    render 'reports/show', status: :unprocessable_entity
  end
end
