class UsersController < ApplicationController
  # NOTE:  These before_action methods execute in the order given, so order here is important
  before_action :set_user, only: %i[ edit update show destroy ]
  before_action :require_user, only: %i[ edit update destroy ]
  before_action :require_same_user, only: %i[ edit update destroy ]
  def new
    @user = User.new
  end

  def create
    # NOTE:  When a new user signes up, the form includes a password and a password confirmation field
    # Magically, if those entries do not match, teh error will be trapped by @user.save below
    # and the errors will be displayed on the "new" user page.
    # If the password and confirmation match, then create a new user
    @user = User.new(whitelist_params)
    if @user.save
      # Set the newly created (signed-up) user as logged in
      session[:user_id] = @user.id
      # Welcome user and redirect
      flash[:notice]="#{@user.username.capitalize}, welcome to AlphaBlog."
      redirect_to posts_path
    else
      # Error trapping
      # Re-render the "new" user page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render "new", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(whitelist_params)
      flash[:notice] = "Profile updated"
      redirect_to user_path(@user)
    else
      # Error trapping
      # Re-render the "edit" user page.
      # Because the save returned false, the error trapping on the "edit" page
      # will display the errors
      render "edit", status: :unprocessable_entity
    end
  end

  def show
    # In preparation for the user's show page, get all of the posts authored by this user
    @posts = @user.posts.includes(:rich_text_body, :categories)
                        .paginate(page: params[:page], per_page: 5).order(updated_at: :desc)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5).order(username: :desc)
  end

  def destroy
    session[:user_id] = nil if @user == current_user
    @user.destroy
    flash[:notice] = "Your account has been deleted"
    redirect_to root_path
  end

  private
  def whitelist_params
    params.expect(user: [ :username, :email_address, :password, :password_confirmation ])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can only modify your own profile"
      redirect_to @user
    end
  end
end
