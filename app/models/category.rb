class Category < ApplicationRecord
  validates :name, presence: true,
                   length: { minimum: 2, maximum: 100 },
                   uniqueness: { case_sensitive: false }
  has_many :post_categories
  has_many :posts, through: :post_categories
end
