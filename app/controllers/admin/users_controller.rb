class Admin::UsersController < ApplicationController
  before_action :admin_privileges_required

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
        format.html { redirect_to admin_users_path }
      else
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
        format.html { redirect_to admin_users_path}
      else
        format.html { render :edit, status: :unprocessable_entity}
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    
    respond_to do |format|
      if @user.destroy
        flash[:notice] = t(".destroyed")
        format.html { redirect_to admin_users_path }
        format.json { head :no_content }
      else
        flash[:alert] = t("activerecord.errors.models.user.last_admin_deletion")
        format.html { redirect_to admin_users_path }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
  end
end
