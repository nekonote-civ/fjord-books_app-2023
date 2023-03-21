# frozen_string_literal: true

module BooksHelper
  def user_name(user_id)
    user = User.find(user_id)
    user.name.empty? ? user.email : user.name
  end
end
