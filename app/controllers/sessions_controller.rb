class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email_address: params[:session][:email_address])
    password_entry = params[:session][:password]

    if user && user.authenticate(password_entry)
      flash[:notice] = "Login successful"
      session[:user_id] = user.id
      redirect_to user
    else
      # Error trapping
      # Re-render the "new" session page (i.e. the login page).
      # Because we are not dealing with a model here, must display the error message to user directly
      # Using flash.now here because we are not executing a re-direct here, so we want to display the
      # error message when the login form is re-displayed
      flash.now[:alert] = "Entered credentials are not correct"
      render "new", status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logout successful"
    redirect_to root_path
  end

  private

  def whitelist_params
    params.expect(session: [ :user_address, :password ])
  end
end
