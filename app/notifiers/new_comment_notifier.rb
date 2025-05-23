# To deliver this notification:
#
# NewCommentNotifier.with(record: @post, message: "New post").deliver(User.all)

class NewCommentNotifier < ApplicationNotifier
  # Add your delivery methods
  #
  # deliver_by :email do |config|
  #   config.mailer = "UserMailer"
  #   config.method = "new_post"
  # end
  #
  # bulk_deliver_by :slack do |config|
  #   config.url = -> { Rails.application.credentials.slack_webhook_url }
  # end
  #
  # deliver_by :custom do |config|
  #   config.class = "MyDeliveryMethod"
  # end

  # Add required params
  #
  # required_param :message
  #
  notification_methods do
    def message
      @post = Post.find(params[:comment][:post_id])
      @comment = Comment.find(params[:comment][:id])
      @user = User.find(@comment.user_id)
      "#{@user.username} commented on post: #{@post.title.truncate(10)}"
    end
    #
    def url
      post_path(Post.find(params[:comment][:post_id]))
    end
  end
end
