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
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  # Resulting from use of bcrypt gem
  has_secure_password

  # Based on use of Noticed gem
  has_many :notifications, as: :recipient, dependent: :destroy, class_name: "Noticed::Notification"

  # REMINDER: database columns that model enums are type integer
  enum :role, %i[ user admin ], default: :user

  private

  # To support searching.
  # NOTE:  The methods MUST have the names used
  #   [or figure out how to tell ransack gem they have a different same,
  #   which didn't seem worthwhile]
  def self.ransackable_attributes(auth_object = nil)
    [ "username", "email_address" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "comments", "notifications", "posts" ]
  end

  def set_default_role
    self.role ||= :user
  end
end
