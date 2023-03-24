# frozen_string_literal: true

class ReportsController < ApplicationController
  include ApplicationHelper

  before_action :set_report, only: %i[show update destroy edit]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return redirect_to report_path, alert: t('controllers.permission.alert_update', name: Report.model_name.human) unless created_by?(@report.user_id)

    if @report.update(report_params)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to report_url, alert: t('controllers.permission.alert_destroy', name: Report.model_name.human) unless created_by?(@report.user_id)

    @report.destroy
    redirect_to @report, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
