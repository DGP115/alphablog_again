class Post < ApplicationRecord
  validates :title, presence: true,
                    length: { minimum: 2, maximum: 100 }
  validates :body, presence: true,
                   length: { minimum: 6, maximum: 10000 }
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, dependent: :destroy
  has_rich_text :body

  # Based on use of Noticed gem
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"
end
