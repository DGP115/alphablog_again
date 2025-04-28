class UsersController < ApplicationController
  before_action :set_user, only: %i[ edit update show destroy ]
  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelist_params)
    if @user.save
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
    @posts = @user.posts.paginate(page: params[:page], per_page: 5).order(updated_at: :desc)
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 5).order(username: :desc)
  end

  def destroy
  end

  private
  def whitelist_params
    params.expect(user: [ :username, :email_address, :password ])
  end

  def set_user
    @user = User.find(params[:id])
  end
end
