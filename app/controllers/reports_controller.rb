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

    ActiveRecord::Base.transaction do
      report_saved = @report.save
      mentions_saved = report_saved ? create_mentions : false

      if mentions_saved
        redirect_to(@report, notice: t('controllers.common.notice_create', name: Report.model_name.human))
      elsif !report_saved
        render(:new, status: :unprocessable_entity)
        raise ActiveRecord::Rollback
      else
        render('errors/500', status: :internal_server_error)
        logger.error('Mentions save error')
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      report_updated = @report.update(report_params)
      @report.mentioning_relationships.each(&:destroy!)
      mentions_saved = report_updated ? create_mentions : false

      if mentions_saved
        redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
      elsif !report_updated
        render(:edit, status: :unprocessable_entity)
        raise ActiveRecord::Rollback
      else
        render('errors/500', status: :internal_server_error)
        logger.error('Mentions save error')
        raise ActiveRecord::Rollback
      end
    end
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
    mention_reports.all? do |mention_report|
      Mention.create(reports_params(@report.id, mention_report.id))
    end
  end

  def scan_mentioning_reports(content)
    ids = content.scan(REPORTS_REGEXP).flatten.uniq
    Report.where(id: ids)
  end
end
