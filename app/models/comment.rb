class Comment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy,
               cache_depth: true,
               counter_cache: "children_count"
  belongs_to :post
  validates :body, presence: true, length: { minimum: 1, maximum: 500 }
end
