# frozen_string_literal: true

class CommentsController < ApplicationController
  include ApplicationHelper

  before_action :set_comment, only: %i[update destroy edit]

  def edit; end

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to request.referer, notice: 'Successfully posted a comment.'
    else
      redirect_to request.referer, alert: 'Failed to post comment.'
    end
  end

  def update
    return redirect_to root_url, alert: "You don't have update to that comment." unless created_by?(@comment.user_id)

    if @comment.update(comment_params)
      redirect_to polymorphic_path(@comment.commentable), notice: 'Comment was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    return redirect_to request.referer, alert: "You don't have delete to that comment." unless created_by?(@comment.user_id)

    @comment.destroy
    redirect_to request.referer, notice: 'Comment was successfully destroyed.'
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
