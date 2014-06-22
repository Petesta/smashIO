class User < ActiveRecord::Base
  attr_accessible :full_name, :email, :password, :password_confirmation

  has_secure_password

  has_many :videos

  before_create :generate_auth_token

  valid_email_regex = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  validates :full_name, presence: true, length: { maximum: 40 }
  validates :email, presence: true,
            format: { with: valid_email_regex },
            uniqueness: { case_sensitive: false }

  private

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
