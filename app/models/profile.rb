# frozen_string_literal: true

class Profile < ApplicationRecord
  belongs_to :user

  validates :zipcode, presence: true
  validates :address, presence: true
  validates :introduction, presence: true
end
