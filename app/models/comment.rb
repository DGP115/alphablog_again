class Comment < ApplicationRecord
  has_ancestry orphan_strategy: :destroy,
               cache_depth: true,
               counter_cache: "children_count"
  belongs_to :post
  belongs_to :user
  validates :body, presence: true, length: { minimum: 1, maximum: 500 }

  # Using the Noticed gem
  after_create_commit :notify_recipient
  # before_destroy :cleanup_notifications
  # has_noticed_notifications model_name: "Notification"
  # has_many :notifications_as_comment, as: :record, class_name: "Notification", dependent: :destroy
  has_many :notification_events, as: :record, class_name: "Noticed::Event", dependent: :destroy

  private

  def notify_recipient
    NewCommentNotifier.with(record: post, comment: self, post: post).deliver_later(post.user)
  end

  def cleanup_notifications
    notifications_as_comment.destroy_all
  end

  # To support searching.
  # NOTE:  The methods MUST have the names used
  #   [or figure out how to tell ransack gem they have a different same,
  #   which didn't seem worthwhile]
  def self.ransackable_attributes(auth_object = nil)
    [ "body", "title" ]
  end
end
