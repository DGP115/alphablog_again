class ApplicationController < ActionController::Base
  before_action :set_notifications, if: :current_user
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # The helper_method statement makes current_user and logged_in? available to Views
  # In addition to being available to all controllers since they are defined in this parent class
  helper_method :current_user, :logged_in?
  def current_user
    # The below does:
    #   If @current_user has a value, use it.
    #   Otherwise, assign it with the expression after the ||= operator
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    # Recall the !! operator turns any object into a boolean
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:alert] = "You must be logged in to perform that action"
      redirect_to login_path
    end
  end

  def set_notifications
    notifications = current_user.notifications.newest_first.includes(:event)
    @notifications_unread = notifications.unread
    @notifications_read = notifications.read
  end
end
