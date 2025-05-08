class Post < ApplicationRecord
  validates :title, presence: true,
                    length: { minimum: 2, maximum: 100 }
  validates :body, presence: true,
                   length: { minimum: 6, maximum: 10000 }
  belongs_to :user
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, dependent: :destroy
end
