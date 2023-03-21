# frozen_string_literal: true

class CommentsController < ApplicationController
  include ApplicationHelper

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to request.referer, notice: 'Successfully posted a comment.'
    else
      redirect_to request.referer, alert: 'Failed to post comment.'
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    return redirect_to request.referer, alert: "You don't have delete to that comment." unless created_by?(comment.user_id)

    comment.destroy
    redirect_to request.referer, notice: 'Comment was successfully destroyed.'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
