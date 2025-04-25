class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(whitelist_params)
    if @user.save
      flash[:notice]="{#@user.username}, welcome to AlphaBlog."
      redirect_to posts_path
    else
      # Error trapping
      # Re-render the "new" user page.
      # Because the save returned false, the error trapping on the "new" page
      # will display the errors
      render "new", status: :unprocessable_entity
    end
  end

  private
  def whitelist_params
    params.expect(user: [ :username, :email_address, :password ])
  end
end
