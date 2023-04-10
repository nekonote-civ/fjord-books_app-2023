# frozen_string_literal: true

class Book::CommentsController < CommentsController
  before_action :set_commentable, only: :create

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def render_show_commentable
    @book = @commentable
    render 'books/show', status: :unprocessable_entity
  end
end
