# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar do |attachable|
    attachable.variant :thumb, resize_to_limit: [176, 176]
  end

  validate :validate_file_type

  private

  def validate_file_type
    return unless avatar.attached?
    return if ['image/jpeg', 'image/png', 'image/gif'].include?(avatar.blob.content_type)

    avatar.purge
    errors.add(:avatar, I18n.t('errors.messages.file_type', type_list: 'jpeg, png, gif'))
  end
end
