class Comment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy,
               cache_depth: true,
               counter_cache: "children_count"
  belongs_to :post
  belongs_to :user
  validates :body, presence: true, length: { minimum: 1, maximum: 500 }

  # Using the Noticed gem
  after_create_commit :notify_recipient
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: "Notification"

  private

  def notify_recipient
    NewCommentNotifier.with(comment: self, post: post).deliver_later(post.user)
  end

  def cleanup_notifications
    notifications_as_comment.destroy_all
  end
end
