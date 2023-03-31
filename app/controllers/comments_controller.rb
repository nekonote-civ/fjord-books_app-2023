# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[update destroy edit]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to polymorphic_path(@comment.commentable), notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @commentable.comments.destroy(@commentable.comments.last)
      render_show_commentable
    end
  end

  def edit; end

  def update
    unless @comment.created_by?(current_user.id, @comment.user_id)
      return redirect_to polymorphic_path(@comment.commentable), alert: t('controllers.permission.alert_update', name: Comment.model_name.human)
    end

    if @comment.update(comment_params)
      redirect_to polymorphic_path(@comment.commentable), notice: t('controllers.common.notice_update', name: Comment.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @comment.created_by?(current_user.id, @comment.user_id)
      return redirect_to polymorphic_path(@comment.commentable), alert: t('controllers.permission.alert_destroy', name: Comment.model_name.human)
    end

    @comment.destroy
    redirect_to polymorphic_path(@comment.commentable), notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
