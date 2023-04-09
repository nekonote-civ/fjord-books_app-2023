# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  include ApplicationHelper

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)
    begin
      mentions_error = false
      ActiveRecord::Base.transaction do
        @report.save!
        mentions_error = true
        create_mentions
      end
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    rescue ActiveRecord::RecordInvalid => e
      logger.error(e)
      mentions_error ? render('errors/500', status: :internal_server_error) : render(:new, status: :unprocessable_entity)
    end
  end

  def update
    mentions_error = false
    ActiveRecord::Base.transaction do
      @report.update!(report_params)
      mentions_error = true
      @report.mentioning_relationships.each(&:destroy!)
      create_mentions
    end
    redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
  rescue ActiveRecord::RecordInvalid => e
    logger.error(e)
    mentions_error ? render('errors/500', status: :internal_server_error) : render(:edit, status: :unprocessable_entity)
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def reports_params(mentioning_report_id, mentioned_report_id)
    { mentioning_report_id:, mentioned_report_id: }
  end

  def create_mentions
    mention_reports = scan_mentioning_reports(@report.content)
    mention_reports.each do |mention_report|
      Mention.create!(reports_params(@report.id, mention_report.id))
    end
  end

  def scan_mentioning_reports(content)
    content.scan(REPORTS_REGEXP).map do |id|
      Report.find_by(id:)
    end.compact.uniq
  end
end
