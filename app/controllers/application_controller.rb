class ApplicationController < ActionController::Base
  #  For noticed gem operation
  before_action :set_notifications, if: :current_user

  # For the ransack gem used to implement search
  before_action :set_query
  #
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

  def set_query
    # the 'q' variable comes from ransach gem
    # This method must be in this base controller class becuase search is invoked from the navbar
    @query = Post.ransack(params[:q])
  end
end
