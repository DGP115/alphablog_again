class NotificationsController < ApplicationController
  before_action :require_user, only: %i[ destroy destroy_all_read destroy_all_unread ]
  before_action :set_notification, only: %i[ destroy ]
  before_action :require_same_user, only: %i[ destroy destroy_all_read destroy_all_unread ]


  def destroy
    # Delete the user-selected notification
    @notification.destroy
    redirect_to request.url
  end

  def destroy_all_read
    current_user.notifications.read.destroy_all
    redirect_to request.url
  end

  def destroy_all_unread
    current_user.notifications.unread.destroy_all
    redirect_to request.url
  end

  private

  def set_notification
    #  I don't understand why, but I has to make this @notification to get it usable in
    #  require_same_user below
    @notification = current_user.notifications.find(params[:id])
  end

  def require_same_user
    if !current_user && !current_user.admin?
      flash[:alert] = "You can only delete your own notifications"
      redirect_to current_user
    end
  end
end
