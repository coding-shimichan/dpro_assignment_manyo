class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :logout_required, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    if user&.authenticate(params[:session][:password])
      flash[:notice] = t(".created")
      session[:user_id] = user.id
      redirect_to tasks_path
    else
      flash.now[:alert] = t(".failed")
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = t(".destroyed")
    redirect_to new_session_path
  end
end

