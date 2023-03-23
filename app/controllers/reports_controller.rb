# frozen_string_literal: true

class ReportsController < ApplicationController
  include ApplicationHelper

  before_action :set_report, only: %i[show update destroy edit]
  before_action :set_comments, only: %i[show]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @comment = @report.comments.build
  end

  def new
    @report = Report.new
  end

  def edit
    redirect_to reports_path, alert: "You don't have access to that report." unless created_by?(@report.user_id)
  end

  def create
    @report = current_user.reports.build(report_params)
    if @report.save
      redirect_to @report, notice: 'Report was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    return redirect_to root_url, alert: "You don't have update to that report." unless created_by?(@report.user_id)

    if @report.update(report_params)
      redirect_to @report, notice: 'Report was successfully created.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to report_url, alert: "You don't have delete to that report." unless created_by?(@report.user_id)

    @report.destroy
    redirect_to @report, notice: 'Report was successfully destroyed.'
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def set_comments
    @comments = @report.comments.order(:id).where.not(id: nil)
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end
end
