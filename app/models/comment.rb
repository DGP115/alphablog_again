class Comment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy,
               cache_depth: true,
               counter_cache: "children_count"
  belongs_to :post
  belongs_to :user
  validates :body, presence: true, length: { minimum: 1, maximum: 500 }

  # Using the Noticed gem
  after_create_commit :notify_recipient
  #
  # Enable a Turbo Stream broadcast to auto-refresh notifications for recipient
  after_create_commit :broadcast_notification_to_postauthor

  private

  def notify_recipient
    NewCommentNotifier.with(record: post, comment: self, post: post).deliver_later(post.user)
  end

  # To support searching with ransack gem.
  # NOTE:  The methods MUST have the names used
  #   [or figure out how to tell ransack gem they have a different same,
  #   which didn't seem worthwhile]
  def self.ransackable_attributes(auth_object = nil)
    [ "body", "title" ]
  end

  def broadcast_notification_to_postauthor
    broadcast_replace_to(
      "notifications_targetuser_#{post.user_id}", # Unique stream per user
      target: "notifications",                    # DOM ID to replace to
      partial: "layouts/notifications/unread_icon",
      locals: { unread_count: post.notifications.unread.count }
    )
  end
end
