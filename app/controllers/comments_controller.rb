# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show edit update destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user_id = current_user.id

    if @comment.save
      redirect_to request.referer, notice: 'Successfully posted a comment.'
    else
      redirect_to request.referer, alert: 'Failed to post comment.'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
