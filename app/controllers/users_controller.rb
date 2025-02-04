class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  before_action :logout_required, only: [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        flash[:notice] = t(".created")
        log_in(@user)
        format.html { redirect_to tasks_path }
      else
        flash[:alert] = "Something went wrong. Please try again later."
        format.html { render :new, status: :unprocessable_entity}
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = t(".updated")
        format.html { redirect_to user_path(@user.id) }
      else
        flash[:alert] = t(".failed")
        format.html { render :edit, status: :unprocessable_entity}
      end
    end
  end

  def destroy
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
