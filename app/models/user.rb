class User < ApplicationRecord
  has_secure_password

  enum gender: {female: 0, male: 1, other: 2}

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation birthday
gender).freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
            length: {maximum: Settings.user.max_name_length}
  validates :email, presence: true,
            length: {maximum: Settings.user.max_email_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :birthday, presence: true
  validates :gender, presence: true
  validate :birthday_within_valid_years

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  private

  def birthday_within_valid_years
    return if birthday.nil?

    years = Settings.user.birthday_valid_years
    min_date = Time.zone.today - years.years
    return if birthday.between?(min_date, Time.zone.today)

    errors.add(:birthday, :birthday_invalid, years:)
  end
end
