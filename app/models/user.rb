class User < ApplicationRecord
  # force email address to be saved in lower case
  before_save { self.email_address = email_address.downcase }
  validates :username, presence: true,
                       length: { minimum: 3, maximum: 25 },
                       uniqueness: { case_sensitive: false }
  # VALID_EMAIL_REGEX, as defined hee, is a constant [hence all caps]
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email_address, presence: true,
                            uniqueness: { case_sensitive: false },
                            length: { maximum: 105 },
                            format: { with: VALID_EMAIL_REGEX }
  has_many :posts
  # Resulting from use of bcrypt gem
  has_secure_password
end
