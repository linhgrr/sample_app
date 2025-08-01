class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  PERMITTED_ATTRIBUTES = %i(content image).freeze

  scope :newest, -> {order created_at: :desc}

  validates :content, presence: true, length: {maximum: Settings.digit_140}
  validates :image, content_type: {in: Settings.image.allowed_types,
                                   message: :invalid_image_format},
                    size: {less_than: Settings.image.max_size_mb.megabytes,
                           message: :image_too_large}

  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: [Settings.image.display.width,
Settings.image.display.height]
  end
end
