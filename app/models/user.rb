class User < ApplicationRecord
  attr_accessor :remember_token, :session_token, :activation_token, :reset_token

  has_secure_password
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: Relationship.name,
           foreign_key: :follower_id, dependent: :destroy
  has_many :passive_relationships, class_name: Relationship.name,
           foreign_key: :followed_id, dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  enum gender: {female: 0, male: 1, other: 2}

  PERMITTED_ATTRIBUTES = %i(name email password password_confirmation birthday
gender).freeze
  PASSWORD_RESET_ATTRIBUTES = %i(password password_confirmation).freeze
  PASSWORD_RESET_EXPIRATION = 2.hours.freeze
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  scope :recent, -> {order(created_at: :desc)}
  scope :sort_by_name, -> {order(:name)}

  before_save :downcase_email
  before_create :create_activation_digest

  validates :name, presence: true,
            length: {maximum: Settings.user.max_name_length}
  validates :email, presence: true,
            length: {maximum: Settings.user.max_email_length},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  validates :birthday, presence: true
  validates :gender, presence: true
  validate :birthday_within_valid_years
  validates :password, presence: true,
            length: {minimum: Settings.user.min_password_length},
            allow_nil: true

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost:
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def forget
    update_column :remember_digest, nil
  end

  def create_session
    self.session_token = User.new_token
    update_column :remember_digest, User.digest(session_token)
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send("#{attribute}_digest")
    return false unless digest

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Creates password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns reset_digest: User.digest(reset_token),
                   reset_sent_at: Time.zone.now
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Sends password changed email.
  def send_password_changed_email
    UserMailer.password_changed(self).deliver_now
  end

  # Checks expiration of reset token.
  def password_reset_expired?
    reset_sent_at < PASSWORD_RESET_EXPIRATION.ago
  end

  def feed
    Micropost.relate_posts(following_ids << id).newest
  end

  def follow other_user
    following << other_user
  end

  def unfollow other_user
    following.delete other_user
  end

  def following? other_user
    following.include? other_user
  end

  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def birthday_within_valid_years
    return if birthday.nil?

    years = Settings.user.birthday_valid_years
    min_date = Time.zone.today - years.years
    return if birthday.between?(min_date, Time.zone.today)

    errors.add(:birthday, :birthday_invalid, years:)
  end

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
  end
end
