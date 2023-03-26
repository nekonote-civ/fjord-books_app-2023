# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  REPORTS_REGEXP = %r{http://localhost:3000/reports/[0-9]\d+}

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
    mention_reports = scan_mention_reports(@report.content)

    @report.transaction do
      if @report.save
        mention_reports.each do |mention_report|
          Mention.create(mentioning_report_id: @report.id, mentioned_report_id: mention_report.id)
        end
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def update
    if @report.update(report_params)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
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

  def scan_mention_reports(content)
    content.scan(REPORTS_REGEXP).map do |url|
      id = url.split('/').last
      Report.find_by(id:)
    end.compact.uniq
  end
end
