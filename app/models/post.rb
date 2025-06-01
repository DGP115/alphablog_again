class Post < ApplicationRecord
  #  To support use of friendly_id gem
  extend FriendlyId
  #
  validates :title, presence: true,
                    length: { minimum: 2, maximum: 100 }
  validates :body, presence: true,
                   length: { minimum: 6, maximum: 10000 }
  belongs_to :user, counter_cache: true
  has_many :post_categories
  has_many :categories, through: :post_categories
  has_many :comments, dependent: :destroy
  has_rich_text :body

  # Based on use of Noticed gem
  has_many :noticed_events, as: :record, dependent: :destroy, class_name: "Noticed::Event"
  has_many :notifications, through: :noticed_events, class_name: "Noticed::Notification"

  #  To support use of friendly_id gem
  #  The "finders" helper enables set_post methods to work as if we coded Post.friendly.find(params[:id])
  friendly_id :title, use: %i[ slugged history finders ]

  # This method is a callback used by friendly_id gem
  def should_generate_new_friendly_id?
    title_changed? || super
  end

private

  # Ransack gem support
  # The below defines a custom ransack attribute called `post_updated_at`.
  #    - that maps to posts.updated_at.  This is so that when sorting by "updated_at"
  #      ransack knows to specifically use that column of the post, versus every other
  #      model that has a column of that name.
  #   -  'formatter: ->(v) { v } do |parent|' is an Identity lambda.  It leaves the value untouched
  #     (no formatting), so I don't know why it is still needed

  ransacker :post_updated_at, formatter: ->(v) { v } do |parent|
    Arel.sql("posts.updated_at")
  end

  # To support searching.
  # NOTE:  The methods MUST have the names used here as ransack calls them.
  def self.ransackable_attributes(auth_object = nil)
    [ "body", "created_at", "id", "title", "post_updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "categories", "comments", "noticed_events", "notifications", "post_categories", "rich_text_body", "user" ]
  end
end
